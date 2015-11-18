require 'savon'
module Dhl
  module Return
    class API
      DEFAULT_NAMESPACES = {
          "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
          "xmlns:var"     => "https://amsel.dpwn.net/abholportal/gw/lp/schema/1.0/var3bl"
      }

      AMSEL_WSDL     = "https://amsel.dpwn.net/abholportal/gw/lp/schema/1.0/var3ws.wsdl"
      AMSEL_ENDPOINT = "https://amsel.dpwn.net/abholportal/gw/lp/SoapConnector"


      def initialize(config, options = {})
        @client = Savon::Client.new do
          wsdl.document = AMSEL_WSDL
          wsdl.endpoint = AMSEL_ENDPOINT
        end

        @user          = config[:username]
        @password      = config[:password]
        @format        = options[:format]
        @delivery_name = config[:delivery_name]
        @portal_id     = config[:portal_id]


      end


      def book_label(sender, order_id, shipment_reference, customer_reference)
        begin
          #we need this, because savon uses instance_eval => no access to the instance variables inside the block
          format        = @format
          delivery_name = @delivery_name
          portal_id     = @portal_id


          result = @client.request :book_label do
            #attention: debugging messes with the xml object, leading to additional markup in the xml object, because to_s is called on the xml builder.
            soap.xml do |xml|
              xml.soapenv(:Envelope, DEFAULT_NAMESPACES) do |xml|
                xml.soapenv(:Header) do |xml|
                  append_default_header_to_xml(xml)
                end
                xml.soapenv(:Body) do |xml|
                  xml.var(:"BookLabelRequest", { :portalId           => portal_id, :deliveryName => delivery_name,
                                                 :labelFormat        => format, :senderName1 => sender.senderName1, :senderStreet => sender.senderStreet,
                                                 :senderStreetNumber => sender.senderStreetNumber, :senderContactPhone => sender.senderContactPhone, :shipmentReference => shipment_reference,
                                                 :senderBoxNumber    => sender.senderBoxNumber, :senderPostalCode => sender.senderPostalCode, :senderCity => sender.senderCity,
                                                 :senderCareOfName   => sender.senderCareOfName, :senderName2 => sender.senderName2, :customerReference => customer_reference })
                end
              end
            end
          end
          r      = result.to_hash[:book_label_response]

          File.open("#{Rails.root}/public/spree/return/#{order_id}.pdf", 'wb') do |f|
            f.write(Base64.decode64(r[:label]))
          end
          return "#{Rails.root}/public/spree/return/#{order_id}.pdf"
        rescue Savon::Error => error
          raise error
        end

      end


      private

      def append_default_header_to_xml(xml)
        xml.wsse(:Security, { "soapenv:mustUnderstand" => "1",
                              "xmlns:wsse"             => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" }) do |xml|
          xml.wsse(:UsernameToken) do |xml|
            xml.wsse(:Username, @user)
            xml.wsse(:Password, { :Type => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText" }, @password)
          end
        end
      end

    end
  end
end

