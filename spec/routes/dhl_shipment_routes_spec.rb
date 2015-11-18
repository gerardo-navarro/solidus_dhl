require 'spec_helper'

RSpec.describe 'DhlShipmentController', type: :routing do

  routes { Spree::Core::Engine.routes }

  it { expect(get("/admin/orders/1/shipment/create_dhl_shipment")).to be_routable }

  it { expect(get("/admin/orders/1/shipment/create_dhl_shipment")).to route_to(controller: 'spree/admin/shipment_handler/dhl_shipment', action: 'create_dhl_shipment', order_id: '1') }

end
