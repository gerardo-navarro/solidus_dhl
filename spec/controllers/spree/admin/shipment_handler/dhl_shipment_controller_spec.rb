require 'spec_helper'

RSpec.describe Spree::Admin::ShipmentHandler::DhlShipmentController do

  # As the DhlShipmentController extends from Spree::Admin::BaseController, we need to consider the authentication of the controller
  # Fortunately, `stub_authorization!` takes care of that for us.
  stub_authorization!


  SHIPMENT_LABEL_URL = 'http://test-intraship2.dhl.com:80/cartridge.61_TZA/WSPrint?code=1C59B3E2B86469722603179BFCAE577A157BEFB2DC908EC4'

  describe "GET #create_dhl_shipment" do
    
    subject { get :create_dhl_shipment, { order_id: Spree::Order.first.id } }
    
    context "(with shipable order)" do
      
      before(:each) do
        @order = FactoryGirl.create :order_ready_to_ship
        mock_dhl_intraship_client
      end
      
      it 'response HTTP_STATUS.redirect' do
        subject
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to SHIPMENT_LABEL_URL
        
        Spree::Order.first.shipments.each do | order_shipment |
          expect(order_shipment.dhl_label).to eq SHIPMENT_LABEL_URL
        end

      end

      it "handles several shipments in an order" do
        # Adding two more shipments
        @order.shipments << FactoryGirl.create(:shipment)
        @order.shipments << FactoryGirl.create(:shipment)

        expect(DHL_Intraship).to receive(:createShipmentDD) do | arg |
          shipment = arg

          expect(shipment.shipment_items).to be_kind_of Array
          expect(shipment.shipment_items.size).to eq 3
        end.and_return({
          label_url: SHIPMENT_LABEL_URL,
          shipment_number: 'TEST412761521204'
        })

        subject

        expect(response).to redirect_to(SHIPMENT_LABEL_URL)
      end
    end

    context "(without shippable order)" do

      before(:each) do
        @order = FactoryGirl.create :order
        mock_dhl_intraship_client
      end

      it "handles orders without any shipment" do
        subject

        expect(response).to have_http_status(:error)
      end
    end

    # context "(without HTTP connection)" do

    #   it 'responds gracefully with error' do
    #     @order = FactoryGirl.create :order_ready_to_ship

    #     subject

    #     expect(response).to have_http_status(:error)
    #   end

    # end

  end


  
  # config/initializer/dhl_intraship_client_options.rb does not create the constant when it is run in the test mode. This means that we need to create it. Because we are mocking the constant we do not care how it is instantiated
  ::DHL_Intraship = {}
  def mock_dhl_intraship_client
    allow(DHL_Intraship).to receive(:createShipmentDD).with(kind_of(Dhl::Intraship::Shipment)).and_return({
      label_url: SHIPMENT_LABEL_URL,
      shipment_number: 'TEST412761521204'
    })
  end
end