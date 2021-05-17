#!/bin/bash

gardenctl target garden $1
REGEX=$2

seeds=$(gardenctl ls seeds | awk 'NR > 1 {print $3}')
rm -fr test-result
mkdir test-result

for seed in $seeds
do
    mkdir "test-result/$seed"
    kubeconfig=$(gardenctl target seed $seed | awk -F'=' 'NR > 1 {print $2}')
    fluent_bit_pods=$(kubectl --kubeconfig=$kubeconfig -n garden get pod -l app=fluent-bit | awk ' IF NR>1 {print $1}')

    echo "Checking seed $seed"
    for pod in $fluent_bit_pods 
    do  
        result=$(kubectl --kubeconfig=$kubeconfig -n garden logs $pod | grep "$REGEX")
        if [ ! -z "$result" ]
        then 
            echo "Pod $pod has $result\n"
            echo "$result\n" > "test-result/$seed/$pod"
        fi
    done

done
