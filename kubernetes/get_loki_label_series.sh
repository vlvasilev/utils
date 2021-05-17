#!/bin/bash
LANDSCAPES=(live-virtual)
OUTPUT_DIR=${1:-"."}
OUTPUT_FILE="$OUTPUT_DIR/loki-label-series-result"
mkdir -p $OUTPUT_DIR
touch $OUTPUT_FILE
LOKI_ADDR=http://localhost:3100

for lanscape in $LANDSCAPES
do
    echo "LANDSCAPE: ${lanscape}" >> $OUTPUT_FILE
    echo "-------------------------------------------------" >> $OUTPUT_FILE
    gardenctl target garden "${landscape}" > /dev/null 2>&1
    seeds=$(gardenctl ls seeds | awk '{print $3}')
    for seed in $seeds
    do
        echo "SEED: ${seed}" >> $OUTPUT_FILE
        kubeconfig=$(gardenctl target seed "${seed}" | grep KUBECONFIG | awk  -F "="  '{print $2}')
        loki_pod=$(kubectl --kubeconfig=$kubeconfig -n garden get pod 2> /dev/null | grep loki-0 )
        if [[ -z "${loki_pod}" ]]
        then
             echo "Loki is missing or not installed" >> $OUTPUT_FILE
            continue
        fi
        pod_status=$(kubectl --kubeconfig=$kubeconfig -n garden get pod loki-0 | tail -n1 | awk '{print $2}')
        if [[ "${pod_status}" != "1/1" ]]
        then
            echo "Loki is not running" >> $OUTPUT_FILE
            continue
        fi
        inode_usage=$(kubectl --kubeconfig=$kubeconfig -n garden exec loki-0 -- df /data/loki/chunks/ -hi | tail -n1 | awk '{print $5}' | sed 's/%$//')
        echo "INODE USAGE: $inode_usage%" >> $OUTPUT_FILE
        kubectl --kubeconfig=$kubeconfig -n garden port-forward svc/loki 3100:3100 &
        sleep 10
        logcli series --analyze-labels {} >> $OUTPUT_FILE
        process_id=$(jobs -l | awk '{print $2}')
        kill -9 $process_id
        echo "********" >> $OUTPUT_FILE
    done
    echo "-------------------------------------------------" >> $OUTPUT_FILE
done
