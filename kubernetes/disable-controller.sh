#!/bin/bash

gardenkubeconfig=$1
controllerregistration=$2
controller=$3

echo $gardenkubeconfig $controllerregistration $controller
#stop controller
kubectl --kubeconfig=$gardenkubeconfig patch controllerregistration $controllerregistration --type=merge -p="{\"spec\":{\"deployment\":{\"providerConfig\":{\"values\":{\"disableControllers\": [\"$controller\"]}}}}}"