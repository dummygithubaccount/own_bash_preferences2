#!/bin/bash


function search_for_client {
  
  cd $HOME/workspace
  
  #directories=($(ls -l | grep "^d" | awk '{print $9}'))

  cd $HOME/workspace #/${directories[$i]}
             
  grep --color=always --exclude-dir={log,vendor,public,script,tmp,}  -irn $1 *
}

function exclude_dirs {
  
  excluded="{"
  for item in "${excluded_dirs[@]}"
  do
    excluded+="$item,"
  done
  excluded=${excluded%?}
  excluded+="}"

  echo $excluded
}

excluded_dirs=(
"log"
"vendor"
)
search_for_client $1
