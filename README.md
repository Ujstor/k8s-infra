# k8s infrastructure & configuration as code



Deploy Kubernetes cluster on Hetzner Cloud using the [kube-hetzner/terraform-hcloud-kube-hetzner](https://github.com/kube-hetzner/terraform-hcloud-kube-hetzner) repository. This project aims to create a highly optimized, auto-upgradable, highly available and cost-effective Kubernetes cluster on Hetzner Cloud.

## Prerequisites

Before you begin, ensure you have the following:

- A Hetzner Cloud account. You can sign up for one [here](https://hetzner.cloud/?ref=Ix9xCKNxJriM).
- The following command-line tools installed:
  - [Terraform](https://www.terraform.io/downloads.html)
  - [Packer](https://www.packer.io/downloads)
  - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  - [hcloud CLI](https://github.com/hetznercloud/cli)



## Deployment Steps

### 1. Generate SSH Keys

Generate a passphrase-less SSH key pair to be used for the cluster.

```shell
ssh-keygen -t ed25519 -N "" -f ~/.ssh/hcloud-kube-hetzner
```

### 2. Create Your kube.tf File and Snapshot

- Create a project in your Hetzner Cloud Console and obtain an API key with "Read & Write" permissions.
- Navigate to the directory where you want to deploy the cluster and execute the following command to create your kube.tf file and the required MicroOS snapshot:

For bash:

```shell
tmp_script=$(mktemp) && curl -sSL -o "${tmp_script}" https://raw.githubusercontent.com/kube-hetzner/terraform-hcloud-kube-hetzner/master/scripts/create.sh && chmod +x "${tmp_script}" && "${tmp_script}" && rm "${tmp_script}"
```

For fish shell:

```shell
set tmp_script (mktemp); curl -sSL -o "{tmp_script}" https://raw.githubusercontent.com/kube-hetzner/terraform-hcloud-kube-hetzner/master/scripts/create.sh; chmod +x "{tmp_script}"; bash "{tmp_script}"; rm "{tmp_script}"
```

This command will help you set up a new folder with the required files and guide you through the creation of a needed MicroOS snapshot.

### 3. Customize kube.tf

In your project folder, you will find the `kube.tf` file. Customize this file to suit your needs, specifying variables such as the number of control-plane and agent nodes, CNI choice, and other cluster configurations. An example of a `cube.tf` file is in the root of this repository.

### 4. Initialize and Apply Terraform

Now that you have your `kube.tf` file ready, initialize Terraform and apply the configuration:

```shell
cd <your-project-folder>
terraform init --upgrade
terraform validate
terraform apply -auto-approve
```

This process will take approximately 5 minutes to complete, and you will receive confirmation of a successful deployment.

### 5. Access and Manage Your Cluster

Once the cluster is deployed, you can access and manage it:

- To access the cluster details, use:

  ```shell
  terraform output kubeconfig
  ```

- To manage your cluster with `kubectl`, either SSH into a control-plane node or use the Kube API.

### 6. Scaling and Maintenance

You can scale the number of nodes and node pools, configure add-ons, and manage the cluster as per your requirements. Refer to the project documentation for detailed information on these topics.

### 7. Cleanup

When you are finished with your cluster, you can destroy it and release the associated resources using Terraform:

```shell
terraform destroy -auto-approve
```

Alternatively, you can use the provided cleanup script for a more comprehensive cleanup:

```shell
tmp_script=$(mktemp) && curl -sSL -o "${tmp_script}" https://raw.githubusercontent.com/kube-hetzner/terraform-hcloud-kube-hetzner/master/scripts/cleanup.sh && chmod +x "${tmp_script}" && "${tmp_script}" && rm "${tmp_script}"
```

This script will remove all resources related to your cluster.

## Upgrading the Module

To upgrade the module to the latest version, modify the version attribute in your `kube.tf` file and apply the configuration using Terraform.