# kdevops

kdevops is a framework to let you easily get your Linux devops environment
going for whatever use case you have. The first use case is to provide a
devops environment for Linux kernel development testing, and hence the name.

kdevops relies on vagrant, terraform and ansible to get you going with whatever
your virtualization / bare metal / cloud provisioning environment easily.

There are three parts to the long terms ideals for kdevops:

1. Provisioning required virtual hosts / cloud environment
2. Provisioning your requirements
3. Running whatever you want

Vagrant or terraform are used for the first part. Vagrant and terraform are
also used to kick off ansible later for the second part of the provisioning, to
get all requirements installed.

What works?

  * Full vagrant provisioning
  * Initial terraform provisioning on different cloud providers
  * Running ansible to install dependencies on debian

What's missing?

  * Hooking up terraform with ansible. For this perhaps [the terraform ansible module](https://registry.terraform.io/modules/radekg/ansible/provisioner/2.2.0).
  * A way to automate getting your vagrant / cloud provider IP address to your ssh config so we can later run with ansible (you can use vagrant ssh-config for now)

### Vagrant support - localized VMs

Vagrant is used to easily deploy non-cloud virtual machines. Below are
the list of providers supported:

  * Virtualbox
  * libvirt (KVM)

The following Operating Systems are supported:

  * OS X
  * Linux

#### Provisioning with vagrant

If on Linux we'll assume you are using KVM. If on OS X we'll assume you are
using Virtualbox. If these assumptions are incorrect you can override on the
configuration file for your node provisioning. For instance, the demo you'd
use vagrant/nodes.yaml and set the force_provider variable to either "libvirt"
or "kvm". However, since you would typically keep your vagrant/nodes.yaml file
in version control you can instead use an environment variable:

  * OSCHECK_VAGRANT_PROVIDER

You are responsible for having a pretty recent system with some fresh
libvirt, or vitualbox installed. For instance, a virtualbox which supports
nvme.

```bash
cd vagrant/
vagrant up
```

Say you want to just test the provisioning mechanism:

```bash
vagrant provision
```
##### Limitting vagrant's number of boxes

By default the using vagrant will try to create *all* the nodes specified on
your configuration file. By default this is nodes.yml and there are currently 7
nodes there. If you are going to just test this framework you can limit this
initially using environment variables:

```bash
export OSCHECK_VAGRANT_LIMIT_BOXES="yes"
export OSCHECK_VAGRANT_LIMIT_NUM_BOXES=1
```

This will ensure only the first host, for example, would be created and
provisioned. This might be useful if you are developing on a laptop, for
example, and you want to limit the amount of resources used.

### Terraform support

Terraform is used to deploy your solution on cloud virtual machines. Below are
the list of clouds currently supported:

  * azure
  * openstack (special minicloud support added)
  * aws

#### Provisioning with terraform

```bash
cd terraform/you_provider
make deps
terraform init
terraform plan
terraform apply
```

## Running ansible

Before running ansible make sure you can ssh into the hosts listed on ansible/hosts.

```bash
cd ansible/
ansible-playbook -i hosts oscheck.yml
```

## qemu kernel configs

For now we supply kernel configs used to build the vanilla / stable kernels
tested.  These are purposely trimmed to be minimal for use on qemu KVM guests
to run a generic kernel tests. They are under:

	qemu-kernel-configs/

License
-------

This work is licensed under the GPLv2, refer to the [LICENSE](./LICENSE) file
for details. Please stick to SPDX annotations for file license annotations.
If a file has no SPDX annotation the GPLv2 applies. We keep SPDX annotations
with permissive licenses to ensure upstream projects we embraced under
permissive licenses can benefit from our changes to their respective files.
