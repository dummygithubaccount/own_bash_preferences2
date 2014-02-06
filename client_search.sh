#!/bin/bash


function search_for_client {
  
  cd $HOME/workspace
  
  directories=($(ls -l | grep "^d" | awk '{print $9}'))
    
  for i in ${!directories[@]}
  do
    cd $HOME/workspace/${directories[$i]}
                
    if [ -f "Gemfile" ];
    then
      grep_contents=$(grep -irn "$1" Gemfile)
      if [ -n "$grep_contents" ];
      then 
        echo "********${directories[$i]}/Gemfile**********"
        echo $grep_contents
      fi
    fi
  done
}

search_for_client $1
