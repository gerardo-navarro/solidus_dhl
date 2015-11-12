class AddDhlFieldsToSpreeShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :dhl_label, :string
    add_column :spree_shipments, :shipment_number, :string
  end
end
