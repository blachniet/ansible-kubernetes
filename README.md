# Ansible Kubernetes

Create a single control-plane Kubernetes cluster with kubeadm and Ansible.

```bash
# Confirm SSH access to host and add to hosts file.
echo "192.168.20.30" >> hosts

# Create virtual environment with Ansible.
python3 -m venv .ansible
source .ansible/bin/activate
pip install ansible

# Run the playbook.
ansible-playbook --ask-become-pass --inventory hosts playbook.yml
```

## Links

- [Installing kubeadm]

[Installing kubeadm]: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
