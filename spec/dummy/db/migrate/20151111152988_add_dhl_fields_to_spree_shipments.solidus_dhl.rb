# This migration comes from solidus_dhl (originally 20151111085629)
class AddDhlFieldsToSpreeShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :dhl_label, :string
    add_column :spree_shipments, :shipment_number, :string
  end
end
