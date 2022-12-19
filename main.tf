
##Terraform
# This module creates DNS A-type records defined as JSON files by using DNS Terraform provider. Each json file correspond to one DNS A record and contains all the necessary 
# attributes.
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
## JSON File Name --> DNS Record Name
## JSON File Object --> Attributes of a DNS Record
## Example:
exercise.json
{
    "addresses": [
        "192.168.200.1"
    ],
    "ttl": 600,
    "zone": "example.com.",
    "dns_record_type": "a"
}

After processing the above xml and querying the DNS service with host IP 192.168.18.111 , the output should be: 

[matulo@olivo1 exercise-terraform-dns-updater]$ nslookup exercise.example.com 192.168.18.111
Server:         192.168.18.111
Address:        192.168.18.111#53
Name:   exercise.example.com
Address: 192.168.200.1
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

locals {
  json_files = fileset("input-json", "*.json") // get all json file names
}
# ----------------------------------------
# Write your Terraform module inputs here
# ----------------------------------------

resource "dns_a_record_set" "www" {
  for_each = local.json_files  
  zone = jsondecode(file("input-json/${each.key}")).zone //extract the value of the key zone from the json file   
  addresses = jsondecode(file("input-json/${each.key}")).addresses // extract the list of IPs addresses from the json file 
  ttl =  jsondecode(file("input-json/${each.key}")).ttl // extrat the value of the key TTL from the json file
  name = trimsuffix(each.key,".json") // get the subdomain from the json file name 
}