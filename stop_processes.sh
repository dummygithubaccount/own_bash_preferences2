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
"silverpop_mock"
)

pids=($(ps aux | grep init-file | awk '{print $2}'))

for item in "${pids[@]}" 
do
  kill -9 $item
done


for item in "${services[@]}" 
do
  if [ -f "$HOME/workspace/$item/tmp/pids/server.pid" ]
  then
    pid=$(cat "$HOME/workspace/$item/tmp/pids/server.pid")
    kill -9 $pid
  else
    echo "$item was not running."
  fi
done

rm -rf $HOME/own_bash_preferences2/tmp_bashrc

