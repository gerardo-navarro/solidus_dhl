## Solidus DHL [![Build Status](https://circleci.com/gh/gerardo-navarro/solidus_dhl.png?style=shield&circle-token=7b649cdb55ba2d7f4c80418c894aa38a97876828)](https://circleci.com/gh/gerardo-navarro/solidus_dhl) ##

Solidus DHL integrate the DHL Intraship API with the solidus system.

### Getting Started ###

To add solidus_dhl, add the following to your Gemfile.

`gem 'solidus_dhl', github: 'gerardo-navarro/solidus_dhl'`

Run `bundle` command to install. Make sure you have ruby-2.1.2 or higher set as your ruby environment.

After installing gems, you'll have to run the generators to create necessary configuration files and migrations.

`bundle exec rake solidus_dhl:install:migrations`

Run migrations to create the new models in the database.

`bundle exec rake db:migrate`

We are using Figaro which looks for `${Rails.root}/config/application.yml` to inject the environment variables, e.g. dhl credentials. Add the following to the `${Rails.root}/config/application.yml` (create the file if necessary).

```
DHL_INTRASHIP_API_USER:   'some_api_user'
DHL_INTRASHIP_API_PWD:    'ABC-123-DEF-456'
DHL_INTRASHIP_USER:       'geschaeftskunden_api'
DHL_INTRASHIP_SIGNATURE:  'Dhl_ep_test12345'
DHL_INTRASHIP_EKP:        '5000000000'
```

Finally, start the rails server

`bundle exec rails s`

Go to any order in `localhost:3000/admin/orders`. On the right corner you will find 3 additional links that will create new shipment labels with the DHL Api.

## Testing this gem ##

 - `cd spec/dummy`
 - `cp config/application.yml.default config/application.yml`
 - `RAILS_ENV=test bundle exec rake db:test:prepare`
 - `bundle exec rake db:test:prepare`
 - `cd ../..`
 - `bundle exec rspec`

You can look into `circle.yml` to see how it is tested on the CI server.
