#!/bin/bash

LANDSCAPE=$1
SEED_REGEX=$2
CHUNKS_TO_BE_RETANED=$3

gardenctl target garden $1
seeds=$(gardenctl ls seeds | grep "$2" | awk '{print $3}')

for seed in $seeds
do
    kubeconfig=$(gardenctl target seed $seed | grep KUBECONFIG | awk  -F "="  '{print $2}')
    namespaces=$(kubectl --kubeconfig=$kubeconfig get ns | grep "shoot-" | awk '{print $1}')
    echo "SEED $seed"
    for ns in $namespaces
    do
        is_loki=$(kubectl --kubeconfig=$kubeconfig -n $ns get pod | grep loki | wc -l)
        if [[ "$is_loki"=="1" ]]
        then
            echo "NAMESPACE $ns"
            last_n_chunks=$(kubectl --kubeconfig=$kubeconfig -n $ns exec loki-0 ls -- /data/loki/chunks -1t | tail -n +$CHUNKS_TO_BE_RETANED | xargs rm -f)
        fi
    done
done
