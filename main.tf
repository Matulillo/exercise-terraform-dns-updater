##Terraform
# This module creates DNS A-type and CNAME records defined as JSON files by using DNS Terraform provider. Each json file correspond to one DNS type A or CNAME record 
# and contains all the necessary attributes.
# The json files are located under the folder ./input-json and works with any number of JSON files, non-json files will be ignored. 
# The DNS authoritative zone will always be example.com.  
#
## Usage
# The get the environment ready a DNS service has to be spun up via Docker either in the local machine or in a remote server by running the shell script
# available under tests (tests/build-and-run.sh). Assume host computer is xNIX-like Operating System with bash and docker)
# It mocks out a local DNS service based on BIND9 with no authentication in order to test the Terraform module. 
#  
# ---------------------------------------------------------------------------------------------------------------------
### Quick Example
/*
# Example of JSON File structure
├── input-json
│   ├── subdomain-a.json
│   └── subdomain-b.json
│   └── (...).json
## ---------------------------------------------------
## Example: Record type A
## JSON File Name --> DNS Record Name 
## JSON File Object --> Attributes of a DNS Record
exercise.json
{
    "addresses": [
        "192.168.200.1"
    ],
    "ttl": 600,
    "zone": "example.com.",
    "dns_record_type": "a"
}
## -----------------------------------------------------
## Example2: Record type CNAME
## JSON File Name --> DNS Record Name 
## JSON File Object --> Attributes of a DNS Record
exercise2.json
{
    "cname" : "bar.example.com."
    "ttl": 600,
    "zone": "example.com.",
    "dns_record_type": "c"
}
## ------------------------------------------------------

## After processing the above jsons files and querying the DNS service with host IP 192.168.18.111 , the output should be: 

## A record:
[matulo@olivo1 exercise-terraform-dns-updater]$ nslookup exercise.example.com 192.168.18.111
Server:         192.168.18.111
Address:        192.168.18.111#53
Name:   exercise.example.com
Address: 192.168.200.1

## CNAME record
[matulo@olivo1 exercise-terraform-dns-updater]$ nslookup -q=cname exercise2.example.com 192.168.18.111
Server:         192.168.18.111
Address:        192.168.18.111#53
exercise2.example.com   canonical name = bar.example.com.

# ---------------------------------------------------------------------------------------------------------------------
*/

# ---------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM RUNTIME REQUIREMENTS
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  # This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
  # This module is now only being tested with Terraform 0.13.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 0.13.x code.
  required_version = ">= 0.13.5"
  required_providers {
    dns = {
      source  = "hashicorp/dns"
      version = ">= 3.2.0"
    }
  }
}

# Configure the DNS Provider
provider "dns" {
  update {
    server = var.dns_server
  }
}
# Local variables
locals{
  // get all json file names 
  json_files = fileset("input-json", "*.json")  

  // filter json files with A type records
  a_record_json_files = toset([ for f in local.json_files : f if jsondecode(file("input-json/${f}")).dns_record_type == "a"])
  
  // filter json files with cname type records
  cnames_record_json_files = toset([ for f in local.json_files : f if jsondecode(file("input-json/${f}")).dns_record_type == "c"])
}
# A type record resources
resource "dns_a_record_set" "www" {
  for_each = local.a_record_json_files
  zone = jsondecode(file("input-json/${each.key}")).zone
  addresses = jsondecode(file("input-json/${each.key}")).addresses
  ttl = jsondecode(file("input-json/${each.key}")).ttl
  name = trimsuffix(each.key,".json")
}
# CNAMAE type record resources
resource "dns_cname_record" "cn" {
  for_each = local.cnames_record_json_files
  zone = jsondecode(file("input-json/${each.key}")).zone
  cname = jsondecode(file("input-json/${each.key}")).cname
  ttl = jsondecode(file("input-json/${each.key}")).ttl
  name = trimsuffix(each.key,".json")
}