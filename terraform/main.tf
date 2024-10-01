#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = "develop"
}
#создаем подсеть
resource "yandex_vpc_subnet" "develop" {
  name           = "develop-ru-central1-a"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

#считываем данные об образе ОС
data "yandex_compute_image" "centos7" {
  family = var.vm_image
}

#создаем 2 идентичные ВМ во внутренней или внешней сети в зависимости от бастиона
resource "yandex_compute_instance" "clickhouse" {
  count = 1
  name        = "clickhouse"
  platform_id = var.platform
  resources {
    cores         = var.clickhouse_cores
    memory        = var.clickhouse_memory
    core_fraction = var.clickhouse_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos7.image_id
      type     = var.storage_disk_type
      size     = var.hdd_vol_size
    }
  }
  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
  scheduling_policy { preemptible = true }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = true

  }
  allow_stopping_for_update = true
}

resource "yandex_compute_instance" "vector" {
  count = 1
  name        = "vector"
  platform_id = var.platform
  resources {
    cores         = var.vector_cores
    memory        = var.vector_memory
    core_fraction = var.vector_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos7.image_id
      type     = var.storage_disk_type
      size     = var.hdd_vol_size
    }
  }
  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
  scheduling_policy { preemptible = true }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = true
    #nat_ip_address = yandex_vpc_address.addr.external_ipv4_address[0].address
  }
  allow_stopping_for_update = true
}

resource "yandex_compute_instance" "lighthouse" {
  count = 1
  name        = "lighthouse"
  platform_id = var.platform
  resources {
    cores         = var.lighthouse_cores
    memory        = var.lighthouse_memory
    core_fraction = var.lighthouse_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos7.image_id
      type     = var.storage_disk_type
      size     = var.hdd_vol_size
    }
  }
  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
  scheduling_policy { preemptible = true }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = true
  }
  allow_stopping_for_update = true
}