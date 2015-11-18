module Spree
  module Admin
    module ShipmentHandler

      class DhlShipmentController < Spree::Admin::BaseController
        # rescue_from ::SolidusDhl::Errors::SolidusDhlError, with: :render_error


        def create_dhl_return
          order_id = params[:order_id]
          @order   = Spree::Order.find(order_id)

          sender                    = Sender.new
          ship_address              = @order.user.ship_address
          sender.senderName1        = ship_address.firstname
          sender.senderName2        = ship_address.lastname
          sender.senderStreet       = ship_address.address1
          sender.senderStreetNumber = "0" #TODO needs to be parsed out of address1
          sender.senderCity         = ship_address.city
          sender.senderPostalCode   = ship_address.zipcode
          sender.senderContactPhone = ship_address.phone

          send_file DHL_Return.book_label(sender, order_id, "", ""), :filename => 'return_label.pdf', :type => 'application/pdf', :disposition => "inline"
        end


        def create_dhl_shipment

          order_id = params[:order_id]
          @order   = Spree::Order.find(order_id)

          if @order.shipments.empty?
            error = { error: '@order.shipments cannot be empty' }
            render json: error, status: 500
            return
          end

          if @order.order_stock_locations.empty?

            sender_address =
              Dhl::Intraship::CompanyAddress.new(company:        'Vecommerce',
                                                 contact_person: 'Markt der Zukunft',
                                                 street:         'Überseering',
                                                 house_number:   '34',
                                                 zip:            '22297',
                                                 city:           'Hamburg',
                                                 country_code:   'DE',
                                                 email:          'info@vecommerce.net')
          else
            sender_address = SolidusDhl::Client::SpreeAddressConverter.convert(@order.order_stock_locations.stock_location)
          end

          receiver_address = SolidusDhl::Client::SpreeAddressConverter.convert(@order.ship_address)

          # Use can use multiple parcels per shipment. Note that the weight
          # parameter is in kg and the length/height/width in cm
          shipments = @order.shipments.map do | order_shipment |
            # The order shipment is not necessary at the moment, but it will be in future
            Dhl::Intraship::ShipmentItem.new(weight: 3, length: 120, width: 60, height: 60)
          end

          shipment =
              Dhl::Intraship::Shipment.new(sender_address:   sender_address,
                                           receiver_address: receiver_address,
                                           shipment_items:   shipments,
                                           shipment_date:    Date.today)

          result = DHL_Intraship.createShipmentDD(shipment)

          raise 'label_url not returned' unless result[:label_url]

          @order.shipments.each do |shipment|
            shipment.update({
              dhl_label:        result[:label_url],
              shipment_number:  result[:shipment_number],
              tracking:         result[:shipment_number]
            })
          end

          redirect_to result[:label_url]

        end


        def get_dhl_shipment_label

          order_id = params[:order_id]
          @order   = Spree::Order.find(order_id)

          redirect_to :edit unless @order.shipments.first.dhl_label

          redirect_to @order.shipments.first.dhl_label

        end

        def render_error(error)
          render(json: error, status: error.status)
        end

      end
    end
  end
end
