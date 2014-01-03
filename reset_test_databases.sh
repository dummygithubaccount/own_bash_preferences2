#!/bin/bash

services=(
"turnstile"
"customerservice"
"entry_service"
"catalog_service"
"orders_service"
"competition_management"
"payment_service"
"communication_service"
"offer_service"
)

function reset_databases {
bundle exec rake db:reset RAILS_ENV=test
bundle exec rake db:migrate RAILS_ENV=test
}



for item in "${services[@]}" 
  do
    cd $HOME/workspace/$item
    reset_databases &
  done
wait
echo "All test databases reset and migrated!"



