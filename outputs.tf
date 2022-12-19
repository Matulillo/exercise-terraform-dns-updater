# ----------------------------------------
# Write your Terraform module outputs here
# ----------------------------------------
output "DNS_Host_Server" {
    value = var.dns_server
    description = "DNS IP host server where the docker with bind9 service is running"
}

output "Subdomains_Records_Updated" {
  description = "List of subdomains updated and its atributes"
  value = [for r in dns_a_record_set.www : "Subdomain ${r.name}.example.com | TTL ${r.ttl} | IPs ${join( " - ", r.addresses)}" ] 
}


