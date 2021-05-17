#!/bin/bash

resource_type=$1
kubeconfig=$2
namespace=$3
worker=$4


#get worker resource
fetch_curl_result=$(curl http://127.0.0.1:8001/apis/extensions.gardener.cloud/v1alpha1/namespaces/${namespace}/${resource_type}s/${worker}/status -o $HOME/tmp/worker-status.raw.json --write-out %{http_code})
if [ ! "$fetch_curl_result"="200" ]; then echo "Can't get worker resource!"; exit 1; fi

#remove status.lastOperation from the downloaded worker resource
cat $HOME/tmp/worker-status.raw.json | jq -M 'del(.status.lastOperation)' > $HOME/tmp/worker-status.json
sed_result=$(cat $HOME/tmp/worker-status.json | jq '.status.lastOperation')
if [ ! "$sed_result"="null" ]; then echo "Can't remove .status.lastOperation from downloaded worker status!"; exit 1; fi

# update the worker status
update_curl_result=$(curl -i -XPUT -H "Content-type: application/json" -d @$HOME/tmp/worker-status.json http://127.0.0.1:8001/apis/extensions.gardener.cloud/v1alpha1/namespaces/${namespace}/${resource_type}s/${worker}/status)
if [ ! "$update_curl_result"="200" ]; then echo "Didn't remove the lastOperation entry from worker status!"; exit 1; fi

#check if we managed to remove the lastOperation from worker status
lastOperation=$(kubectl --kubeconfig=$kubeconfig -n $namespace get $resource_type $worker -o json | jq '.items[].status.lastOperation')
if [ ! "$lastOperation"="null" ]; then echo "Can't remove .status.lastOperation !"; exit 1; fi
