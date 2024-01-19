terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

resource "libvirt_volume" "ubuntu-volume" {
  name   = "${var.domain_name}-root"
  pool   = var.pool_name
  source = var.source_image
  format = "qcow2"
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud-init/cloud_init.cfg")
  vars = {
    domain_name    = var.domain_name
    network_zone   = var.network_zone
    ssh_public_key = file(var.ssh_public_key_path)
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/cloud-init/network_config.cfg")
  vars = {
    network_zone    = var.network_zone
    network_address = var.network_address
    network_bits    = var.network_bits
    network_gateway = var.network_gateway
  }
}

resource "libvirt_cloudinit_disk" "cloudinit_disk" {
  name           = "${var.domain_name}-cloudinit_disk"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = var.pool_name
}

resource "libvirt_domain" "domain-ubuntu" {
  name   = var.domain_name
  memory = var.domain_memory
  vcpu   = var.domain_vcpu

  cloudinit = libvirt_cloudinit_disk.cloudinit_disk.id

  network_interface {
    network_name = var.network_name
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.ubuntu-volume.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
