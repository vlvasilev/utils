#!/bin/bash

controllerinstallation=$1

curl -iL -XPUT -H "Content-type: application/json" -d @$HOME/tmp/controllerinstallations-status.raw.json http://127.0.0.1:8001/apis/core.gardener.cloud/v1beta1/controllerinstallations/${controllerinstallation}/status
