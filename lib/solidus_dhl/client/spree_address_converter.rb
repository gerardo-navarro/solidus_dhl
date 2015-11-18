module SolidusDhl
  module Client
    class SpreeAddressConverter
      def self.convert(spree_address)
        spree_address_street_segments = spree_address.address1.chomp.split(' ')
        # Take everything but the last
        street                        = spree_address_street_segments[0...-1].join(' ')
        house_number                  = spree_address_street_segments.last

        Dhl::Intraship::PersonAddress.new(
          firstname:  spree_address.firstname,
          lastname: spree_address.lastname,
          # email:  'john.doe@example.com',
          street: street,
          house_number: house_number,
          street_additional: spree_address.address2 || '',
          zip: spree_address.zipcode,
          city: spree_address.city,
          country_code: spree_address.country.iso)
      end
    end
  end
end
