output "nat_ip_addresses" {
  description = "NAT IP addresses of all VMs"
  value = {
    clickhouse  = yandex_compute_instance.clickhouse[0].network_interface[0].nat_ip_address
    lighthouse  = yandex_compute_instance.vector[0].network_interface[0].nat_ip_address
    vector      = yandex_compute_instance.lighthouse[0].network_interface[0].nat_ip_address
  }
} 
