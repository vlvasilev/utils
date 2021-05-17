#!/bin/bash

KUBECONFIG=$1
REGEX=$2

fluent_bit_pods=$(kubectl --kubeconfig=$KUBECONFIG -n garden get pod -l app=fluent-bit | awk ' IF NR>1 {print $1}')

for pod in $fluent_bit_pods 
do
    result=$(kubectl --kubeconfig=$KUBECONFIG -n garden logs $pod | grep "$REGEX")
    if [ ! -z "$result" ]
    then 
        echo "Pod $pod has $result\n"
    fi
done
