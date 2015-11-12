module Spree
  module Admin
    module ShipmentHandler

      class DhlShipmentController < Spree::Admin::BaseController


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

          sender_address =
              Dhl::Intraship::CompanyAddress.new(company:        'Vecommerce',
                                                 contact_person: 'Markt der Zukunft',
                                                 street:         'Überseering',
                                                 house_number:   '34',
                                                 zip:            '22297',
                                                 city:           'Hamburg',
                                                 country_code:   'DE',
                                                 email:          'info@vecommerce.net')

          order_ship_address = @order.ship_address

          receiver_address   =
              Dhl::Intraship::PersonAddress.new(firstname:         order_ship_address.firstname,
                                                lastname:          order_ship_address.lastname,
                                                street:            order_ship_address.address1,
                                                house_number:      '10',
                                                street_additional: order_ship_address.address2,
                                                zip:               order_ship_address.zipcode,
                                                city:              order_ship_address.city,
                                                country_code:      order_ship_address.country.iso,
                                                email:             'john.doe@example.com')

          # Use can use multiple parcels per shipment. Note that the weight
          # parameter is in kg and the length/height/width in cm
          shipments          = []
          (1..@order.shipments.count).each do |shipment_no|
            shipment_item =
                Dhl::Intraship::ShipmentItem.new(weight: 3,
                                                 length: 120,
                                                 width:  60,
                                                 height: 60)
            shipments << shipment_item
          end

          shipment =
              Dhl::Intraship::Shipment.new(sender_address:   sender_address,
                                           receiver_address: receiver_address,
                                           shipment_items:   shipments,
                                           shipment_date:    Date.today)

          result = DHL_Intraship.createShipmentDD(shipment)

          raise 'label_url not returned' unless result[:label_url]

          @order.shipments.each do |shipment|
            shipment.dhl_label       = result[:label_url]
            shipment.shipment_number = result[:shipment_number]
            shipment.tracking        = result[:shipment_number]
            shipment.save
          end


          redirect_to result[:label_url]

        end


        def get_dhl_shipment_label

          order_id = params[:order_id]
          @order   = Spree::Order.find(order_id)

          redirect_to :edit unless @order.shipments.first.dhl_label

          redirect_to @order.shipments.first.dhl_label

        end

      end

    end
  end
end
