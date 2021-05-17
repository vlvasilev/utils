#!/bin/bash

number_of_logs=$1

for msg_number in {1..$number_of_logs}
do
    echo "$(date) This message is generated from a flooder and the number of it is $msg_number"
done