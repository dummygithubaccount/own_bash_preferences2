#!/bin/bash


function check_out_services {
  
  cd $HOME/workspace
  
  directories=($(ls -lt | awk '{print $9}'))
    
  for i in ${!directories[@]}
  do
    cd $HOME/workspace/${directories[$i]}
                
    git checkout .
    echo "checked out ${directories[$i]}"
  done
}

check_out_services

