#!/bin/bash

kubeconfig=$1
project=$2
pod_name=$3

namespaces=$(kubectl --kubeconfig=$kubeconfig get ns -o name | grep $project)

for ns in $namespaces;
do
    pods=$(kubectl --kubeconfig=$kubeconfig -n $ns get pod -o name | grep $pod_name)
    for pod in pods;
    do
       kubectl --kubeconfig=$kubeconfig -n $ns delete $pod
    done   
done
