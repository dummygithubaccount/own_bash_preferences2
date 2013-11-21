#!/bin/bash

pids=($(ps aux | grep init-file | awk '{print $2}'))

for item in "${pids[@]}" 
do
  kill -9 $item
done

