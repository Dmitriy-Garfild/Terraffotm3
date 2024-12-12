######
resource "yandex_compute_instance" "db" {

  for_each = { for vm in local.vms_bav: "${vm.vm_name}" => vm }
  name = each.key
  platform_id = var.vm_web_platform_id
  zone           = var.default_zone
  resources {
        cores           = each.value.cpu
        memory          = each.value.ram
        core_fraction = each.value.frac
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = local.vms_metadata
  
}

locals {
  vms_bav = [
        {
        vm_name = "main"
        cpu     = 4
        ram     = 4
        frac    = 20
        },
        {
        vm_name = "replica"
        cpu     = 2
        ram     = 2
        frac    = 20
        }
  ]
}

