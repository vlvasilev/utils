#!/bin/bash
kubeconfig=$1
namespace=$2

kubectl --kubeconfig=$kubeconfig delete ns $namespace & 
for resource_type in $(kubectl --kubeconfig=$kubeconfig api-resources --verbs=list --namespaced -o name); 
do 
    echo "Delete \"$resource_type\" resource type"
    for resource in $(kubectl --kubeconfig=$kubeconfig -n $namespace get $resource_type -o name); 
    do  
        echo "Delete \"$resource\" resource"
        kubectl --kubeconfig=$kubeconfig -n $namespace patch $resource --type=json -p='[{"op": "remove", "path": "/spec/finalizers"}]'; 
        kubectl --kubeconfig=$kubeconfig -n $namespace patch $resource --type=json -p='[{"op": "remove", "path": "/metadata/finalizers"}]'; 
    done; 
done;