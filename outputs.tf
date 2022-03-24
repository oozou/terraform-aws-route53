output "route53_name" {
  description = "Name of Route53 zone"
  value       = element(concat(aws_route53_zone.this[*].name, [""]), 0)
}

output "route53_zone_id" {
  description = "Zone ID of Route53 zone"
  value       = element(concat(aws_route53_zone.this[*].zone_id, [""]), 0)
}

output "route53_name_servers" {
  description = "Name servers of Route53 zone"
  value       = element(concat(aws_route53_zone.this[*].name_servers, [""]), 0)
}

output "route53_record_name" {
  description = "The name of the record"
  value       = { for k, v in aws_route53_record.this : k => v.name }
}

output "route53_record_fqdn" {
  description = "FQDN built using the zone domain and name"
  value       = { for k, v in aws_route53_record.this : k => v.fqdn }
}
