module "kube-hetzner" {
  providers = {
    hcloud = hcloud
  }
  hcloud_token = var.hcloud_token

  source = "github.com/kube-hetzner/terraform-hcloud-kube-hetzner"

  ssh_public_key  = file("~/.ssh/hcloud-kube-hetzner.pub")
  ssh_private_key = file("~/.ssh/hcloud-kube-hetzner")
  network_region  = "eu-central"

  control_plane_nodepools = [
    {
      name        = "control-plane-fsn1",
      server_type = "cpx11",
      location    = "fsn1",
      labels      = [],
      taints      = [],
      count       = 1
      # swap_size   = "2G" # remember to add the suffix, examples: 512M, 1G
      # zram_size   = "2G" # remember to add the suffix, examples: 512M, 1G
      # kubelet_args = ["kube-reserved=cpu=250m,memory=1500Mi,ephemeral-storage=1Gi", "system-reserved=cpu=250m,memory=300Mi"]

      # Fine-grained control over placement groups (nodes in the same group are spread over different physical servers, 10 nodes per placement group max):
      # placement_group = "default"

      # Enable automatic backups via Hetzner (default: false)
      # backups = true
    },
    {
      name        = "control-plane-nbg1",
      server_type = "cpx11",
      location    = "nbg1",
      labels      = [],
      taints      = [],
      count       = 1
    },
    {
      name        = "control-plane-hel1",
      server_type = "cpx11",
      location    = "hel1",
      labels      = [],
      taints      = [],
      count       = 1
    }
  ]

  agent_nodepools = [
    {
      name                = "agent-small-1",
      server_type         = "cpx11",
      location            = "fsn1",
      labels              = [],
      taints              = [],
      count               = 1
      longhor_volume_size = 50
    },
    {
      name                = "agent-small-2",
      server_type         = "cpx11",
      location            = "nbg1",
      labels              = [],
      taints              = [],
      count               = 1
      longhor_volume_size = 50
    },
    {
      name                = "agent-small-3",
      server_type         = "cpx11",
      location            = "nbg1",
      labels              = [],
      taints              = [],
      count               = 1
      longhor_volume_size = 50
    },
  ]

  load_balancer_type           = "lb11"
  load_balancer_location       = "fsn1"
  load_balancer_disable_ipv6   = true
  load_balancer_algorithm_type = "least_connections"


  # etcd_s3_backup = {
  #   etcd-s3-endpoint        = "xxxx.r2.cloudflarestorage.com"
  #   etcd-s3-access-key      = "<access-key>"
  #   etcd-s3-secret-key      = "<secret-key>"
  #   etcd-s3-bucket          = "k3s-etcd-snapshots"
  # }


  enable_longhorn        = true
  longhorn_namespace     = "longhorn-system"
  longhorn_fstype        = "xfs"
  longhorn_replica_count = 3
  # Also, you can choose to use a Hetzner volume with Longhorn. By default, it will use the nodes own storage space, but if you add an attribute of
  # longhorn_volume_size (⚠️ not a variable, just a possible agent nodepool attribute) with a value between 10 and 10000 GB to your agent nodepool definition, it will create and use the volume in question.
  # See the agent nodepool section for an example of how to do that.

  # traefik_redirect_to_https = false

  # allow_scheduling_on_control_plane = true

  # Adding extra firewall rules, like opening a port
  # More info on the format here https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall
  # extra_firewall_rules = [
  #   {
  #     description = "For Postgres"
  #     direction       = "in"
  #     protocol        = "tcp"
  #     port            = "5432"
  #     source_ips      = ["0.0.0.0/0", "::/0"]
  #     destination_ips = [] # Won't be used for this rule
  #   },
  #   {
  #     description = "To Allow ArgoCD access to resources via SSH"
  #     direction       = "out"
  #     protocol        = "tcp"
  #     port            = "22"
  #     source_ips      = [] # Won't be used for this rule
  #     destination_ips = ["0.0.0.0/0", "::/0"]
  #   }
  # ]

  # enable_cert_manager = false

  # You could create multiple A records of to let's say cp.cluster.my.org pointing to all of your control-plane nodes ips.
  # In which case, you need to define that hostname in the k3s TLS-SANs config to allow connection through it. It can be hostnames or IP addresses.
  # additional_tls_sans = ["cp.cluster.my.org"]

  # Export the values.yaml files used for the deployment of traefik, longhorn, cert-manager, etc.
  # This can be helpful to use them for later deployments like with ArgoCD.
  export_values = true
}

provider "hcloud" {
  token = var.hcloud_token
}

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.43.0"
    }
  }
}

output "kubeconfig" {
  value     = module.kube-hetzner.kubeconfig
  sensitive = true
}

variable "hcloud_token" {
  sensitive = true
  default   = ""
}
