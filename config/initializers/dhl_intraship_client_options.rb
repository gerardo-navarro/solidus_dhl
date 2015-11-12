# configure intraship:
config_intraship = {
    api_user: ENV['DHL_INTRASHIP_API_USER'],
    api_pwd: ENV['DHL_INTRASHIP_API_PWD'],
    user: ENV['DHL_INTRASHIP_USER'],
    signature: ENV['DHL_INTRASHIP_SIGNATURE'],
    ekp: ENV['DHL_INTRASHIP_EKP']
}

options_intraship = {
    test: true, # If test is set, all API calls go against the Intraship test system
    label_response_type: :xml # If it's set to XML the createShipment-Calls return the label data as XML instead of the PDF-Link
}

unless Rails.env.test?
  ::DHL_Intraship = Dhl::Intraship::API.new(config_intraship, options_intraship)
end

# configure returns:

config_return = {
    username: 'ws_online_retoure',
    password: 'Anfang1!',
    portal_id: 'OnlineRetoure',
    delivery_name: 'Deutschland_Var3'
}

options_return = {
    format: 'PDF'
}

unless Rails.env.test?
  ::DHL_Return = Dhl::Return::API.new(config_return, options_return)
end


