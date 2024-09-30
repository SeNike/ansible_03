#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = "develop"
}
#создаем подсеть
resource "yandex_vpc_subnet" "develop" {
  name           = "develop-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

#resource "yandex_vpc_address" "addr" {
#  name = "clickhouse-address"#
#
#  external_ipv4_address {
#    zone_id = "ru-central1-a"
#  }
#}

#считываем данные об образе ОС
data "yandex_compute_image" "centos7" {
  family = "centos-7-oslogin"
}


#создаем 2 идентичные ВМ во внутренней или внешней сети в зависимости от бастиона
resource "yandex_compute_instance" "clickhouse" {
  count = 1
  name        = "clickhouse"
  platform_id = "standard-v1"
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos7.image_id
      type     = "network-hdd"
      size     = 10
    }
  }
  metadata = {
    ssh-keys = "centos:${var.ssh_key}"
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
  platform_id = "standard-v1"
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos7.image_id
      type     = "network-hdd"
      size     = 10
    }
  }
  metadata = {
    ssh-keys = "centos:${var.ssh_key}"
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
  platform_id = "standard-v1"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos7.image_id
      type     = "network-hdd"
      size     = 10
    }
  }
  metadata = {
    ssh-keys = "centos:${var.ssh_key}"
  }
  scheduling_policy { preemptible = true }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = true
    #nat_ip_address = yandex_vpc_address.addr.external_ipv4_address[0].address
  }
  allow_stopping_for_update = true
}

