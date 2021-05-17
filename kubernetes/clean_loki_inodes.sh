#!/bin/bash
# Usage: ./loki-scheck.sh  85 80 false
# In percentages
INODE_USAGE_LIMIT=${1:-85}
# In percentages
INODE_USAGE_TARGET=${2:-80}
DELETE_CHUNKS_IF_LIMIT_EXEEDED=${3:-true}
LANDSCAPES=(canary-virtual live-virtual)
wait_until_pod_is_running () {
    ns=$1
    pod=$2
    pod_status=$(kubectl --kubeconfig=$kubeconfig -n $ns get pod $pod | tail -n1 | awk '{print $2}')
    if [[ "${pod_status}" != "1/1" ]]
    then
        echo "Waiting Loki pod in Garden: ${landscape}; Seed: ${seed}; Namespace ${ns} to become in running state..."
        while [[ "${pod_status}" != "1/1" ]]
        do
            sleep 5
            pod_status=$(kubectl --kubeconfig=$kubeconfig -n $ns get pod $pod | tail -n1 | awk '{print $2}')
        done
        echo "Loki pod is in running state"
    fi
}
check_inodes () {
  namespaces=$1
  for ns in $namespaces
  do
    loki_pod=$(kubectl --kubeconfig=$kubeconfig -n $ns get pod 2> /dev/null | grep loki )
    if [[ -z "${loki_pod}" ]]
    then
        continue
    fi
    wait_until_pod_is_running "${ns}" "loki-0"
    inode_usage=$(kubectl --kubeconfig=$kubeconfig -n $ns exec loki-0 -- df /data/loki/chunks/ -hi | tail -n1 | awk '{print $5}' | sed 's/%$//')
    if [[ "${inode_usage}" -gt "${INODE_USAGE_LIMIT}" ]]
    then      
        echo "Garden: ${landscape}; Seed: ${seed}; Namespace ${ns}; Inode usage: ${inode_usage}%"
        if [[ "${DELETE_CHUNKS_IF_LIMIT_EXEEDED}" == "true" ]]
        then
            max_inodes_available=$(kubectl --kubeconfig=$kubeconfig -n $ns exec loki-0 -- df /data/loki/chunks/ -i | tail -n1 | awk '{print $3}')
            target_inodes=$(( INODE_USAGE_TARGET * max_inodes_available / 100  + 1 ))
            chunks_for_deletion=$(( max_inodes_available - target_inodes ))
            echo "${chunks_for_deletion} chunks will be deleted..."
            kubectl --kubeconfig=$kubeconfig -n $ns exec loki-0 sh -- -c "cd /data/loki/chunks; ls -1t | tail -n +${target_inodes} | xargs rm -f"
        fi
    fi
  done
}
for landscape in "${LANDSCAPES[@]}"
do 
    echo "LANDSCAPE: ${landscape}"
    echo "-------------------------------------------------"
    gardenctl target garden "${landscape}" > /dev/null 2>&1
    seeds=$(gardenctl ls seeds | awk '{print $3}')
    for seed in $seeds
    do
        echo "SEED: ${seed}"
        kubeconfig=$(gardenctl target seed "${seed}" | grep KUBECONFIG | awk  -F "="  '{print $2}')
        namespaces=(garden)
        check_inodes "${namespaces}"
        #namespaces=$(kubectl --kubeconfig=$kubeconfig get ns -l gardener.cloud/role=shoot -o custom-columns=NAME:.metadata.name --no-headers)
        #check_inodes "${namespaces[@]}"
    done
done