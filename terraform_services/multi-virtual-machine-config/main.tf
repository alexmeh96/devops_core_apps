terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

locals {
  project_name = "ubuntu-server"

  network_domain = "alexcoder.com"
  network_mask = "10.22.5.0"
  network_bits = 24
}

resource "libvirt_network" "network" {
  name = "${local.project_name}-network"

  autostart = true
  mode = "nat"
  domain = local.network_domain
  addresses = [
    "${local.network_mask}/${local.network_bits}"
  ]

  dns {
    enabled = true
    local_only = true
  }
}

resource "libvirt_pool" "pool" {
  name = "${local.project_name}-pool"
  type = "dir"
  path = "/home/alex/work/qemu/${local.project_name}"
}

module "node1" {
  count = 5

  source = "./domain"

  domain_name = "${local.project_name}-node-${count.index}"
  domain_memory = "2000"
  domain_vcpu = "2"

  pool_name = libvirt_pool.pool.name

  network_name = libvirt_network.network.name
  network_zone = local.network_domain
  network_address = cidrhost("${local.network_mask}/${local.network_bits}", sum([
    20,
    count.index]))
  network_bits = local.network_bits
  network_gateway = "10.22.5.1"

  source_image = "/home/alex/work/qemu/images/ubuntu-22.04-server-cloudimg-amd64.img"

  ssh_public_key_path = "/home/alex/.ssh/alex.pub"
}

resource "local_file" "inventory_file" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    nodes = module.node1
  })
  filename = "./inventory.ini"
}
