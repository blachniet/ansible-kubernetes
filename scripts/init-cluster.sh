#!/bin/bash

set -e

# Initialize the master node.
kubeadm init

export KUBECONFIG=/etc/kubernetes/admin.conf

# Install Calico (pod network add-on).
kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml

# Allow master to schedule pods.
kubectl taint nodes --all node-role.kubernetes.io/master-

# Create a file indicating that we ran this script.
touch /usr/local/src/kubeadm-initialized
