# Ansible Kubernetes

Create a single node Kubernetes cluster with kubeadm and Ansible.

1. Confirm that you have SSH access to the host.
1. Use Ansible to provision the host.

    ```bash
    # Save the host connection details.
    echo "192.168.20.30" >> hosts

    # Create virtual environment with Ansible.
    python3 -m venv .ansible
    source .ansible/bin/activate
    pip install ansible

    # Run the playbook.
    ansible-playbook --ask-become-pass --inventory hosts playbook.yml
    ```

1. SSH into the host. Execute the remaining steps on the host.
1. [Initialize the control-plane node.][1]

    ```bash
    # Initialize the node.
    sudo kubeadm init
    ```

1. Save the output from `kubeadm init` for reference later.

1. Follow the instructions in `kubeadm init` to allow your user to use `kubectl`.

1. [Install a Pod network add-on][2]. For this example, we use Calico.

    ```bash
    kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml
    ```

1. [Allow the master to schedule pods.][3]

    ```bash
    kubectl taint nodes --all node-role.kubernetes.io/master-
    ```

Calico for pod network.

## Offline

This section includes some special considerations for offline installations.

List images that kubeadm requires.

```bash
$ kubeadm config images list
k8s.gcr.io/kube-apiserver:v1.18.5
k8s.gcr.io/kube-controller-manager:v1.18.5
k8s.gcr.io/kube-scheduler:v1.18.5
k8s.gcr.io/kube-proxy:v1.18.5
k8s.gcr.io/pause:3.2
k8s.gcr.io/etcd:3.4.3-0
k8s.gcr.io/coredns:1.6.7
```

List and retrieve Calico images.

```bash
$ calico_version=v3.14

# List images that this version of Calico requires.
$ curl -s https://docs.projectcalico.org/${calico_version}/manifests/calico.yaml | grep image | awk '{print $2}' | sort | uniq
calico/cni:v3.14.1
calico/kube-controllers:v3.14.1
calico/node:v3.14.1
calico/pod2daemon-flexvol:v3.14.1

# Pull all the Docker images for Calico.
$ images=$(curl -s https://docs.projectcalico.org/${calico_version}/manifests/calico.yaml | grep image | awk '{print $2}' | sort | uniq)
$ for image in $images; do sudo docker pull "$image"; done
```

## Links

- [Installing kubeadm]
- [Creating a single control-plane cluster with kubeadm]

[Installing kubeadm]: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
[Creating a single control-plane cluster with kubeadm]: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
[1]: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#initializing-your-control-plane-node 
[2]: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network
[3]: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#control-plane-node-isolation