require 'spec_helper'

RSpec.describe SolidusDhl::Client::SpreeAddressConverter do

  it 'converts normal ship address' do

    spree_address = FactoryGirl.build :solidus_dhl_ship_address

    address = SolidusDhl::Client::SpreeAddressConverter.convert(spree_address)

    general_assertions(address)

    expect(address.street).to eq 'Stahnsdorfer Str.'
    expect(address.house_number).to eq '154a'
    expect(address.street_additional).to eq ''
    expect(address.zip).to eq '14482'
    expect(address.city).to eq 'Potsdam'
  end

  it 'converts ship address with umlauts' do

    spree_address = FactoryGirl.build :solidus_dhl_ship_address_with_umlauts

    address = SolidusDhl::Client::SpreeAddressConverter.convert(spree_address)

    expect(address.street).to eq 'Krähenstieg'
    expect(address.house_number).to eq '2'
    expect(address.street_additional).to eq 'Dachgeschoss Rechts'
    expect(address.zip).to eq '33914'
    expect(address.city).to eq 'Madgeburg'
  end

  it 'converts ship address with letter in house number' do

    spree_address = FactoryGirl.build :solidus_dhl_ship_address_with_letter_in_house_number

    address = SolidusDhl::Client::SpreeAddressConverter.convert(spree_address)

    expect(address.street).to eq 'Birkhahnkamp'
    expect(address.house_number).to eq '19b'
    expect(address.zip).to eq '22846'
    expect(address.city).to eq 'Norderstedt'
  end


  it 'converts weird ship address' do
    # Weird ship address with with many whitespaces
    check_correct_conversion('   New-York-Ring        6         ', 'New-York-Ring', '6')
    check_correct_conversion('Mendelsohn    Bartholdy   Straße        123', 'Mendelsohn Bartholdy Straße', '123')

    # Weird ship address with one letter seperated from house number
    check_correct_conversion('Stahnsdorfer Str. 154 a', 'Stahnsdorfer Str.', '154a')

    # Weird ship address with only one street name and no house number
    check_correct_conversion('Stahnsdorfer', 'Stahnsdorfer', nil)
    check_correct_conversion('Stahnsdorfer Str.', 'Stahnsdorfer Str.', nil)
  end

  private
  def check_correct_conversion(given_order_ship_address_street, expected_street, expected_house_number)
    spree_address = FactoryGirl.build(:solidus_dhl_ship_address, address1: given_order_ship_address_street)
    address = SolidusDhl::Client::SpreeAddressConverter.convert(spree_address)

    expect(address.street).to eq expected_street
    expect(address.house_number).to eq expected_house_number
  end

  def assert_not_nil_fields(address)
    expect(address.street).to_not be_nil
    expect(address.house_number).to_not be_nil
    expect(address.street_additional).to_not be_nil
    expect(address.zip).to_not be_nil
    expect(address.city).to_not be_nil
  end

  def general_assertions(address)
    expect(address).to_not be_nil
    expect(address).to be_a Dhl::Intraship::PersonAddress
    expect(address.firstname).to eq 'John'
    expect(address.lastname).to eq 'Doe'
    expect(address.country_code).to eq 'DE'

    assert_not_nil_fields(address)
  end

end
