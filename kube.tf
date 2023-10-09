locals {
  hcloud_token = "XXXXXX"
}
module "kube-hetzner" {
  providers = {
    hcloud = hcloud
  }
  hcloud_token = var.hcloud_token != "" ? var.hcloud_token : local.hcloud_token
  source = "kube-hetzner/kube-hetzner/hcloud"
  ssh_public_key = file("~/.ssh/id_ed25519.pub")
  ssh_private_key = file("~/.ssh/id_ed25519")
  network_region = "eu-central" 
  control_plane_nodepools = [
    {
      name        = "control-plane-fsn1",
      server_type = "cpx11",
      location    = "fsn1",
      labels      = [],
      taints      = [],
      count       = 1
    },
    {
      name        = "control-plane-nbg1",
      server_type = "cpx11",
      location    = "nbg1",
      labels      = [],
      taints      = [],
      count       = 0
    },
    {
      name        = "control-plane-hel1",
      server_type = "cpx11",
      location    = "hel1",
      labels      = [],
      taints      = [],
      count       = 0
    }
  ]
  agent_nodepools = [
    {
      name        = "agent-small",
      server_type = "cpx21",
      location    = "fsn1",
      labels      = [],
      taints      = [],
      count       = 2
    },
    {
      name        = "agent-large",
      server_type = "cpx21",
      location    = "nbg1",
      labels      = [],
      taints      = [],
      count       = 0
    },
    {
      name        = "storage",
      server_type = "cpx21",
      location    = "fsn1",
      labels      = [
        "node.kubernetes.io/server-usage=storage"
      ],
      taints      = [],
      count       = 0
      longhorn_volume_size = 30
    },
    {
      name        = "egress",
      server_type = "cpx11",
      location    = "fsn1",
      labels = [
        "node.kubernetes.io/role=egress"
      ],
      taints = [
        "node.kubernetes.io/role=egress:NoSchedule"
      ],
      floating_ip = true
      count = 0
    },
    {
      name        = "agent-arm-small",
      server_type = "cax11",
      location    = "fsn1",
      labels      = [],
      taints      = [],
      count       = 0
    }
  ]
  etcd_s3_backup = {
    etcd-s3-endpoint        = "XXXX.r2.cloudflarestorage.com"
    etcd-s3-access-key      = "XXXXX"
    etcd-s3-secret-key      = "XXXXX"
    etcd-s3-bucket          = "k3s-etcd-snapshots"
  }
  enable_longhorn = true
  ingress_controller = "nginx"
  automatically_upgrade_os = false
}
provider "hcloud" {
  token = var.hcloud_token != "" ? var.hcloud_token : local.hcloud_token
}
terraform {
  required_version = ">= 1.4.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.41.0"
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