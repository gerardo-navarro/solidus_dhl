unless Rails.env.test?
  # require DHL keys:
  Figaro.require_keys('DHL_INTRASHIP_API_USER',
                      'DHL_INTRASHIP_API_PWD',
                      'DHL_INTRASHIP_USER',
                      'DHL_INTRASHIP_SIGNATURE',
                      'DHL_INTRASHIP_EKP')
end

