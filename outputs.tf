
output "DNS_Host_Server" {
    value = var.dns_server
    description = "IP host where the docker with bind9 service is running"
}

output "DNS_A_Records_Updated" {
  description = "List of A records updated and its attributes"
  value = [for r in dns_a_record_set.www : "Subdomain: ${r.name}.example.com | TTL ${r.ttl} | IPs ${join( " - ", r.addresses)}" ] 
}

output "DNS_CNAME_Records_Updated" {
  description = "List of CNAME records updated and its attributes"
  value = [for r in dns_cname_record.cn : "Subdomain: ${r.name}.example.com | TTL ${r.ttl} | Canonical name ${r.cname}" ] 
}

