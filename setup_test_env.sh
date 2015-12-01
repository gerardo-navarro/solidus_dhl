#!/bin/bash

# Makes the bash script to print out every command before it is executed
# set -v
trap '[[ $BASH_COMMAND != echo* ]] && echo $BASH_COMMAND' DEBUG


echo "************************************************************"
if test -d ./spec/dummy
then
  echo "Dummy test app already exists in ./spec/dummy"
  echo "Continuing with setting test env ..."
else
  echo "Creating the dummy app in ./spec/dummy"
  bundle exec rake test_app
fi
echo ""
echo ""

echo "************************************************************"
echo "Copying environment settings into the dummy test app, see ./spec/dummy/config/application.yml"
cp config/application.yml.default spec/dummy/config/application.yml
echo ""
echo ""

echo "************************************************************"
echo "Resetting the test database in ./spec/dummy"
cd spec/dummy ; RAILS_ENV=test bundle exec rake db:drop db:create db:migrate db:test:prepare ; cd ../..
echo ""
echo ""
