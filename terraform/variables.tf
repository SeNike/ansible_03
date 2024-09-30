###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "ssh_key" {
  type        = string
  description = "ssh_key"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "vm_web_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "VM OS image"
}

variable "hdd_vol_size" {
  type = number
  default = 1
  description = "HDD volume size"
}

variable "hdd_quantity" {
  type = number
  default = 3
  description = "quantity of HDD"
}

variable "web_inst_quantity" {
  type = number
  default = 2
  description = "web wm instance quntity"
}

variable "web_platform" {
  type        = string
  default     = "standard-v3"
  description = "WM Platform"
}

variable "storage_platform" {
  type        = string
  default     = "standard-v3"
  description = "WM Platform"
}


variable "each_platform" {
  type        = string
  default     = "standard-v3"
  description = "WM Platform"
}


variable "storage_disk_type" {
  type        = string
  default     = "network-hdd"
  description = "storage_disk_type"
}

variable "each_nat" {
  type        = bool
  default     = true
  description = "nat enable"
}

variable "web_nat" {
  type        = bool
  default     = true
  description = "nat enable"
}

variable "storage_nat" {
  type        = bool
  default     = true
  description = "nat enable"
}

variable "username" {
  type    = string
  default = "ubuntu"
}

variable "ssh_public_key" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "packages" {
  type = list(string)
  default = ["nano"]
}

