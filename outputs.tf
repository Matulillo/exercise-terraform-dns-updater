# ----------------------------------------
# Write your Terraform module outputs here
# ----------------------------------------
output "DNS_Host_Server" {
    value = var.dns_server
    description = "IP host where the docker with bind9 service is running"
}

output "DNS_Records_Updated" {
  description = "List of subdomains updated and its attributes"
  value = [for r in dns_a_record_set.www : "Subdomain ${r.name}.example.com | TTL ${r.ttl} | IPs ${join( " - ", r.addresses)}" ] 
}


