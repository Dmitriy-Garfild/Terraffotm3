resource "yandex_compute_disk" "storage_1" {
  count   = 3
  name  = "disk-${count.index + 1}"
  zone           = var.default_zone
  size  = 1
}


resource "yandex_compute_instance" "storage" {
  name = "storage"
  platform_id = var.vm_web_platform_id
  zone           = var.default_zone
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }

  boot_disk {
    initialize_params {
    image_id = data.yandex_compute_image.ubuntu.image_id
        }
  }

  dynamic "secondary_disk" {
   for_each = { for stor in yandex_compute_disk.storage_1[*]: stor.name=> stor }
   content {
     disk_id = secondary_disk.value.id
   }
  }
  network_interface {
     subnet_id = yandex_vpc_subnet.develop.id
     nat     = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = "ubuntu:${var.vms_ssh_root_key}"
  }
}
