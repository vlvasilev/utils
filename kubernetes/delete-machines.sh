#!/bin/bash

kubectl --kubeconfig ~/tmp/gcp-seed.kubeconfig -n shoot--dev--i330716-gcp-shoot scale deployment machine-controller-manager --replicas=0
for machine_deployment in $(kubectl --kubeconfig ~/tmp/gcp-seed.kubeconfig -n shoot--dev--i330716-gcp-shoot get machinedeployment -o name); do
	kubectl --kubeconfig ~/tmp/gcp-seed.kubeconfig -n shoot--dev--i330716-gcp-shoot patch $machine_deployment --type=json -p='[{"op": "remove", "path": "/metadata/finalizers"}]'
	kubectl --kubeconfig ~/tmp/gcp-seed.kubeconfig -n shoot--dev--i330716-gcp-shoot delete  $machine_deployment
done

for machine_set in $(kubectl --kubeconfig ~/tmp/gcp-seed.kubeconfig -n shoot--dev--i330716-gcp-shoot get machineset -o name); do
	kubectl --kubeconfig ~/tmp/gcp-seed.kubeconfig -n shoot--dev--i330716-gcp-shoot patch  $machine_set --type=json -p='[{"op": "remove", "path": "/metadata/finalizers"}]'
	kubectl --kubeconfig ~/tmp/gcp-seed.kubeconfig -n shoot--dev--i330716-gcp-shoot delete  $machine_set
done

for machine in $(kubectl --kubeconfig ~/tmp/gcp-seed.kubeconfig -n shoot--dev--i330716-gcp-shoot get machine -o name); do
	kubectl --kubeconfig ~/tmp/gcp-seed.kubeconfig -n shoot--dev--i330716-gcp-shoot patch  $machine --type=json -p='[{"op": "remove", "path": "/metadata/finalizers"}]'
    kubectl --kubeconfig ~/tmp/gcp-seed.kubeconfig -n shoot--dev--i330716-gcp-shoot delete  $machine
done
			

