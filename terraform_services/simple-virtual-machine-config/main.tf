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

resource "libvirt_pool" "ubuntu_pool" {
  name = "ubuntu-server-pool"
  type = "dir"
  path = "/home/alex/work/qemu/ubuntu-server"
}

resource "libvirt_volume" "ubuntu_qcow2" {
  name   = "ubuntu-server-qcow2"
  pool   = libvirt_pool.ubuntu_pool.name
  source = "/home/alex/work/qemu/images/ubuntu-22.04-server-cloudimg-amd64.img"
  format = "qcow2"
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud-init/cloud_init.cfg")
  vars = {
    domain_name = "server"
    ssh_public_key = file("/home/alex/.ssh/alex.pub")
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/cloud-init/network_config.cfg")
}

resource "libvirt_cloudinit_disk" "ubuntu_cloudinit_disk" {
  name           = "cloudinit_disk"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.ubuntu_pool.name
}

resource "libvirt_domain" "domain_ubuntu" {
  name   = "ubuntu-server"
  memory = "2048"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.ubuntu_cloudinit_disk.id

  network_interface {
    network_name = "default"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.ubuntu_qcow2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
