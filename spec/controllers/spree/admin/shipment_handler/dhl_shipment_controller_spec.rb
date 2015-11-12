require 'spec_helper'

RSpec.describe Spree::Admin::ShipmentHandler::DhlShipmentController do

  # As the DhlShipmentController extends from Spree::Admin::BaseController, we need to consider the authentication of the controller
  # Fortunately, `stub_authorization!` takes care of that for us.
  stub_authorization!


  SHIPMENT_LABEL_URL = 'http://test-intraship2.dhl.com:80/cartridge.61_TZA/WSPrint?code=1C59B3E2B86469722603179BFCAE577A157BEFB2DC908EC4'

  describe "GET #create_dhl_shipment" do
    
    before(:each) do
      order = FactoryGirl.create :order_ready_to_ship
      mock_dhl_intraship_client
    end
    
    subject { get :create_dhl_shipment, { order_id: Spree::Order.first.id } }
    
    it 'response HTTP_STATUS.ok' do
      subject
      expect(response).to have_http_status(:redirect)
    end

    it "runs without error" do
      subject
      expect(response).to redirect_to(SHIPMENT_LABEL_URL)
    end
  end
  
  # config/initializer/dhl_intraship_client_options.rb does not create the constant when it is run in the test mode. This means that we need to create it. Because we are mocking the constant we do not care how it is instantiated
  ::DHL_Intraship = {}
  def mock_dhl_intraship_client
    allow(DHL_Intraship).to receive(:createShipmentDD).with(anything).and_return({
      label_url: SHIPMENT_LABEL_URL,
      shipment_number: 'TEST412761521204'
    })
  end
end