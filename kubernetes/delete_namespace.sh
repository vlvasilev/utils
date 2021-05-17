#!/bin/bash

kubeconfig=$1 
namespace=$2

kubectl --kubeconfig=$kubeconfig delete ns $namespace &

for resource_type in $(kubectl --kubeconfig=$kubeconfig api-resources --verbs=list --namespaced -o name); do
    for resource in $(kubectl --kubeconfig=$kubeconfig -n $namespace get $resource_type -o name); do
        echo "kubectl --kubeconfig=$kubeconfig -n $namespace patch $resource --type=json -p='[{\"op\": \"remove\", \"path\": \"/spec/finalizers\"}]'"
        kubectl --kubeconfig=$kubeconfig -n $namespace patch $resource --type=json -p='[{"op": "remove", "path": "/spec/finalizers"}]';
        echo "--kubeconfig=$kubeconfig -n $namespace patch $resource --type=json -p='[{\"op\": \"remove\", \"path\": \"/metadata/finalizers\"}]'"
        kubectl --kubeconfig=$kubeconfig -n $namespace patch $resource --type=json -p='[{"op": "remove", "path": "/metadata/finalizers"}]';
    done;
done;