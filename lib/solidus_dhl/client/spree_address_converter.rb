module SolidusDhl
  module Client
    class SpreeAddressConverter
      def self.convert(spree_address)

        # Remove whitespaces surrounding the string and also double whitespaces inside the string
        street_name = spree_address.address1.strip.squeeze(' ')
        address_regex_matcher = /\A(?<street_name>.+)\s(?<house_number>[0-9]+\s?[a-zA-Z]?)\z/.match(street_name)
        
        if address_regex_matcher
          street_name = address_regex_matcher[:street_name]
          house_number = address_regex_matcher[:house_number].delete(' ')
        end

        # spree_address_street_segments = spree_address.address1.chomp.split(' ')

        # # Take everything but the last
        # street                        = spree_address_street_segments[0...-1].join(' ')
        # house_number                  = spree_address_street_segments.last

        Dhl::Intraship::PersonAddress.new(
          firstname:  spree_address.firstname,
          lastname: spree_address.lastname,
          # email:  'john.doe@example.com',
          street: street_name,
          house_number: house_number,
          street_additional: spree_address.address2 || '',
          zip: spree_address.zipcode,
          city: spree_address.city,
          country_code: spree_address.country.iso)
      end
    end
  end
end
