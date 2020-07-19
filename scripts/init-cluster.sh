#!/bin/bash

set -e

# Initialize the master node.
kubeadm init

# Install Calico (pod network add-on).
KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml

# Create a file indicating that we ran this script.
touch /usr/local/src/kubeadm-initialized
