require 'spec_helper'

RSpec.describe SolidusDhl::Client::SpreeAddressConverter do

  it 'convert normal ship address' do

    spree_address = FactoryGirl.build :solidus_dhl_ship_address

    address = SolidusDhl::Client::SpreeAddressConverter.convert(spree_address)

    general_assertions(address)

    expect(address.street).to eq 'Stahnsdorfer Str.'
    expect(address.house_number).to eq '154a'
    expect(address.street_additional).to eq ''
    expect(address.zip).to eq '14482'
    expect(address.city).to eq 'Potsdam'
  end

  it 'convert ship address with umlauts' do

    spree_address = FactoryGirl.build :solidus_dhl_ship_address_with_umlauts

    address = SolidusDhl::Client::SpreeAddressConverter.convert(spree_address)

    expect(address.street).to eq 'Krähenstieg'
    expect(address.house_number).to eq '2'
    expect(address.street_additional).to eq 'Dachgeschoss Rechts'
    expect(address.zip).to eq '33914'
    expect(address.city).to eq 'Madgeburg'
  end

  it 'convert ship address with letter in house number' do

    spree_address = FactoryGirl.build :solidus_dhl_ship_address_with_letter_in_house_number

    address = SolidusDhl::Client::SpreeAddressConverter.convert(spree_address)

    expect(address.street).to eq 'Birkhahnkamp'
    expect(address.house_number).to eq '19b'
    expect(address.zip).to eq '22846'
    expect(address.city).to eq 'Norderstedt'
  end

  private
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
