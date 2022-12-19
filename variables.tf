# ----------------------------------------
# Write your Terraform module inputs here
# ----------------------------------------
variable "dns_server" {
    type = string
    default = "127.0.0.1"
    description = "IP of the host server where the docker with DNS service is running"
}