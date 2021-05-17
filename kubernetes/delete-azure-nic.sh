#!/bin/bash

GROUP=$1

result=$(gardenctl az network nic list -- -g $1) 
NICS=$(echo -n $result | jq '.[].name' -r)
for nic in $NICS
do
    echo "delete $nic"
    gardenctl az network nic delete -- -g $1 -n $nic --no-wait
done

