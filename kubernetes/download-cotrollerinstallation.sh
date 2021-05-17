#!/bin/bash

controllerinstallation=$1

curl http://127.0.0.1:8001/apis/core.gardener.cloud/v1beta1/controllerinstallations/${controllerinstallation}/status -o $HOME/tmp/controllerinstallations-status.raw.json

echo $HOME/tmp/controllerinstallations-status.raw.json
