Spree::Core::Engine.add_routes do

  # namespace :admin do
  #   # An empty array for the 'only' parameter adds no extra route to orders ...
  #   resources :orders, only: [] do
  #     # namespace :shipment do
  #         get create_dhl_shipment: :dhl_shipment
  #         get get_dhl_shipment_label: :dhl_shipment
  #         get create_dhl_return: :dhl_shipment
  #     # end
  #   end
  # end

  get 'admin/orders/:order_id/shipment/create_dhl_shipment' => 'admin/shipment_handler/dhl_shipment#create_dhl_shipment', as: :create_dhl_shipment
  get 'admin/orders/:order_id/shipment/get_dhl_shipment_label' => 'admin/shipment_handler/dhl_shipment#get_dhl_shipment_label', as: :get_dhl_shipment_label
  get 'admin/orders/:order_id/shipment/create_dhl_return' => 'admin/shipment_handler/dhl_shipment#create_dhl_return', as: :create_dhl_return

  # post '/paypal', to: "paypal#express", as: :paypal_express
  # get '/paypal/confirm', to: "paypal#confirm", as: :confirm_paypal
  # get '/paypal/cancel', to: "paypal#cancel", as: :cancel_paypal
  # get '/paypal/notify', to: "paypal#notify", as: :notify_paypal
  #
  # namespace :admin do
  #   # Using :only here so it doesn't redraw those routes
  #   resources :orders, only: [] do
  #     resources :payments, only: [] do
  #       member do
  #         get 'paypal_refund'
  #         post 'paypal_refund'
  #       end
  #     end
  #   end
  # end
end