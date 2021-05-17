#!/bin/bash

GARDEN=$1
NAMESPACE=$2
LABEL=$3

gardenctl target garden $GARDEN
seeds=$(gardenctl ls seeds | awk 'IF NR > 1 {print $3}')

for seed in $seeds; 
do
    export $(gardenctl target seed $seed | grep KUBECONFIG)
    echo SEED: $seed
    kubectl -n $NAMESPACE get pod -l $LABEL
done


