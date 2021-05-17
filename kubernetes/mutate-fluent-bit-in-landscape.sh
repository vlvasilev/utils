#!/bin/bash

KUBECONFIG=$1

kubectl --kubeconfig=$KUBECONFIG -n garden delete -f ~/tmp/block-gardenlet-config-updates.yaml
sleep 20
echo "Downloading fluent-bit cm and ds"
kubectl --kubeconfig=$KUBECONFIG -n garden get cm fluent-bit-config -o yaml > ~/tmp/fluent-bit-config.yaml
if [ "$?"="0" ] 
then
    echo "~/tmp/fluent-bit-config.yaml downloaded"
fi
kubectl --kubeconfig=$KUBECONFIG -n garden get ds fluent-bit -o yaml > ~/tmp/fluent-bit.yaml
if [ "$?"="0" ] 
then
    echo "~/tmp/fluent-bit.yaml downloaded"
fi

echo "Ready?"
read answer
if [ ! "$answer"="y" ]
then 
    return
fi
kubectl --kubeconfig=$KUBECONFIG -n garden apply -f ~/tmp/fluent-bit.yaml
kubectl --kubeconfig=$KUBECONFIG -n garden apply -f ~/tmp/fluent-bit-config.yaml
kubectl --kubeconfig=$KUBECONFIG -n garden apply -f ~/tmp/block-gardenlet-config-updates.yaml