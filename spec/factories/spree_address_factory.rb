FactoryGirl.define do

  factory :solidus_dhl_ship_address, class: Spree::Address do
    firstname 'John'
    lastname 'Doe'
    address1 'Stahnsdorfer Str. 154a'
    city 'Potsdam'
    zipcode '14482'
    phone '0151 15133221'
    alternative_phone '0151 15133221'

    state { |address| address.association(:state_brandenburg) }

    country { |address| address.association(:country_germany) }
  end

  factory :solidus_dhl_ship_address_with_umlauts, parent: :solidus_dhl_ship_address do
    address1 'Krähenstieg 2'
    address2 'Dachgeschoss Rechts'
    city 'Madgeburg'
    zipcode '33914'
    state { |address| address.association(:state_schleswig_holstein) }
  end

  factory :solidus_dhl_ship_address_with_letter_in_house_number, parent: :solidus_dhl_ship_address do
    address1 'Birkhahnkamp 19b'
    city 'Norderstedt'
    zipcode '22846'
    state { |address| address.association(:state_sachsen_anhalt) }
  end

  factory :country_germany, class: Spree::Country do
    iso_name 'GERMANY'
    name 'Bundesrepublik Deutschland'
    iso 'DE'
    iso3 'DEU'
    numcode 276
  end

  factory :state_brandenburg, class: Spree::State do
    name 'Brandenburg'
    abbr 'BR'
    country { |state| state.association(:country_germany) }
  end

  factory :state_schleswig_holstein, parent: :state_brandenburg do
    name 'Schleswig-Holstein'
    abbr 'SW'
  end

  factory :state_sachsen_anhalt, parent: :state_brandenburg do
    name 'Sachsen-Anhalt'
    abbr 'SA'
  end

end
