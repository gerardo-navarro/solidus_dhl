Deface::Override.new(
    virtual_path:  'spree/admin/shared/_order_submenu',
    name:          'initiate_dhl_shipping_tab_links',
    insert_bottom: '[data-hook="admin_order_tabs"]',
    partial:       'spree/admin/orders/initiate_dhl_shipping_tab_links'
)