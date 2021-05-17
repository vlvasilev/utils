#!/bin/bash

KUBECONFIG=$1
NAMESPACE=$2

serviceaccounts=("kube-state-metrics-seed" "prometheus")
rolebindings=("kube-state-metrics-seed")
clusterrolebindings=("prometheus-$NAMESPACE")
services=("kube-state-metrics-seed" "kube-state-metrics" "prometheus" "prometheus-web" "alertmanager-client" "alertmanager")
deployments=("kube-state-metrics-seed" "kube-state-metrics")
verticalpodautoscaler=("kube-state-metrics-seed-vpa" "kube-state-metrics-vpa" "prometheus-vpa")
statfulsets=("prometheus" "alertmanager")
networkpolicies=("allow-from-prometheus" "allow-prometheus")
secrets=("prometheus-basic-auth" "alertmanager-basic-auth" "alertmanager-tls" "alertmanager-config" )
persistenvolumeclaim=("prometheus-db-prometheus-0" "alertmanager-db-alertmanager-0")
ingreses=("prometheus" "alertmanager")

for r in ${serviceaccounts[@]}; do
  kubectl --kubeconfig=$KUBECONFIG -n $NAMESPACE get ServiceAccount $r
done
for r in ${rolebindings[@]}; do
  kubectl --kubeconfig=$KUBECONFIG -n $NAMESPACE get RoleBinding $r
done
for r in ${clusterrolebindings[@]}; do
  kubectl --kubeconfig=$KUBECONFIG -n $NAMESPACE get ClusterRoleBinding $r
done
for r in ${services[@]}; do
  kubectl --kubeconfig=$KUBECONFIG -n $NAMESPACE get Service $r
done
for r in ${deployments[@]}; do
  kubectl --kubeconfig=$KUBECONFIG -n $NAMESPACE get Deployment $r
done
for r in ${verticalpodautoscaler[@]}; do
  kubectl --kubeconfig=$KUBECONFIG -n $NAMESPACE get VerticalPodAutoscaler $r
done
for r in ${statfulsets[@]}; do
  kubectl --kubeconfig=$KUBECONFIG -n $NAMESPACE get StatefulSet $r
done
for r in ${networkpolicies[@]}; do
  kubectl --kubeconfig=$KUBECONFIG -n $NAMESPACE get NetworkPolicy $r
done
for r in ${secrets[@]}; do
  kubectl --kubeconfig=$KUBECONFIG -n $NAMESPACE get Secret $r
done
for r in ${persistenvolumeclaim[@]}; do
  kubectl --kubeconfig=$KUBECONFIG -n $NAMESPACE get PersistentVolumeClaim $r
done
for r in ${ingreses[@]}; do
  kubectl --kubeconfig=$KUBECONFIG -n $NAMESPACE get Ingress $r
done

kubectl --kubeconfig=$KUBECONFIG -n $NAMESPACE get Deployment -l component=grafana
kubectl --kubeconfig=$KUBECONFIG -n $NAMESPACE get ConfigMap -l component=grafana
kubectl --kubeconfig=$KUBECONFIG -n $NAMESPACE get Ingress -l component=grafana
kubectl --kubeconfig=$KUBECONFIG -n $NAMESPACE get Secret -l component=grafana
kubectl --kubeconfig=$KUBECONFIG -n $NAMESPACE get Service -l component=grafana

"component", "grafana", "role", role
		# {"", "v1", "ServiceAccount", "kube-state-metrics-seed"},
		# {"", "v1", "RoleBinding", "kube-state-metrics-seed"},
		# {"", "v1", "Service", "kube-state-metrics-seed"},
		# {"apps", "v1", "Deployment", "kube-state-metrics-seed"},
		# {"autoscaling.k8s.io", "v1beta2", "VerticalPodAutoscaler", "kube-state-metrics-seed-vpa"},

		# {"", "v1", "Service", "kube-state-metrics"},
		# {"autoscaling.k8s.io", "v1beta2", "VerticalPodAutoscaler", "kube-state-metrics-vpa"},
		# {"apps", "v1", "Deployment", "kube-state-metrics"},

		# {"networking", "v1", "NetworkPolicy", "allow-from-prometheus"},
		# {"networking", "v1", "NetworkPolicy", "allow-prometheus"},
		# {"", "v1", "ConfigMap", "prometheus-config"},
		# {"", "v1", "ConfigMap", "prometheus-rules"},
		# {"", "v1", "ConfigMap", "blackbox-exporter-config-prometheus"},
		# {"", "v1", "Secret", "prometheus-basic-auth"},
		# {"extensions", "v1beta1", "Ingress", "prometheus"},
		# {"networking", "v1", "Ingress", "prometheus"},
		# {"autoscaling.k8s.io", "v1beta2", "VerticalPodAutoscaler", "prometheus-vpa"},
		# {"", "v1", "ServiceAccount", "prometheus"},
		# {"", "v1", "Service", "prometheus"},
		# {"", "v1", "Service", "prometheus-web"},
		# {"apps", "v1", "StatefulSet", "prometheus"},
		# {"rbac", "v1", "ClusterRoleBinding", "prometheus-" + b.Shoot.SeedNamespace},
		# {"", "v1", "PersistentVolumeClaim", "prometheus-db-prometheus-0"},