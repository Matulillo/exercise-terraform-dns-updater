## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.5 |
| <a name="requirement_dns"></a> [dns](#requirement\_dns) | >= 3.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_dns"></a> [dns](#provider\_dns) | 3.2.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [dns_a_record_set.www](https://registry.terraform.io/providers/hashicorp/dns/latest/docs/resources/a_record_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_server"></a> [dns\_server](#input\_dns\_server) | IP of the host server where the docker with DNS service is running | `string` | `"127.0.0.1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_DNS_Host_Server"></a> [DNS\_Host\_Server](#output\_DNS\_Host\_Server) | DNS IP host server where the docker with bind9 service is running |
| <a name="output_Subdomains_Records_Updated"></a> [Subdomains\_Records\_Updated](#output\_Subdomains\_Records\_Updated) | List of subdomains updated and its atributes |
