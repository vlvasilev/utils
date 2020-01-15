#!/bin/bash

echo "Check if virtualization is supported"

result=$(grep -E --color 'vmx|svm' /proc/cpuinfo -o | wc -l)

if [ ! $result -gt 0 ]; then
    echo "Virtualization is not supported!"
    exit 1
fi

echo "Virtualization is supported"
echo "Downloading minikube binary."
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

if [ ! -f minikube ]; then 
   echo "Fail to download the minikube binary!"
   exit 2
fi

echo "Minikube binary downloaded."
chmod +x minikube

echo "Making direcotry /usr/local/bin/"

sudo mkdir -p /usr/local/bin/
if [ ! -d "/usr/local/bin/" ]; then
   echo "Failt to make /usr/local/bin/ !"
   exit 3
fi

echo "Instaling minikube"
sudo install minikube /usr/local/bin/

if [ ! -f "/usr/local/bin/minikube" ]; then
   echo "Fail to install minikube!"
   exit 4
fi

minikube version

if [ ! "$?" = "0" ]; then
  echo "Instalation faild!"
  exit 5
fi

echo "Minikube successfully installed!"

echo "Delete minikube binary from current directory."

rm minikube

