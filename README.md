## Solidus DHL ##

Solidus DHL integrate the DHL Intraship API with the solidus system.

### Getting Started ###

bundle exec rake solidus_dhl:install:migrations
bundle exec rake db:migrate



We are using Figaro to inject the options. So add the following to the `config/application.yml`:

```
DHL_INTRASHIP_API_USER:   'some_api_user'
DHL_INTRASHIP_API_PWD:    'ABC-123-DEF-456'
DHL_INTRASHIP_USER:       'geschaeftskunden_api'
DHL_INTRASHIP_SIGNATURE:  'Dhl_ep_test12345'
DHL_INTRASHIP_EKP:        '5000000000'
```


## Testing ##

go into dummy app and copy and paste `config/application.yml.default` to `config/application.yml`
`cd spec/dummy` and `RAILS_ENV=test bundle exec rake db:test:prepare` and `bundle exec rake db:test:prepare`