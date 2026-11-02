variable "image" {
  type = string
}

variable "container_port" {
  type    = number
  default = 8000
}

variable "external_port" {
  type    = number
  default = 8080
}

variable "container_name" {
  type    = string
  default = "campus-notifier-tf"
}
