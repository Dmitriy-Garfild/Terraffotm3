### VM ###
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_ubuntu_2004
}
resource "yandex_compute_instance" "web" {
  depends_on = [ yandex_compute_instance.db ]
  count = 2
  name = "bav-web-${count.index + 1}"
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
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
