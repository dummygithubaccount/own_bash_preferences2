#!/bin/bash

sudo /usr/bin/psql  -h 172.17.0.245 -p 5432 -U developer -d competition_management_uat < get_uat_comp_data.psql
echo "done!!"



