/* -------------------------------------------------------------------------- */
/*                                  Generics                                  */
/* -------------------------------------------------------------------------- */
locals {
  name = format("%s-%s", var.prefix, var.environment)

  hostzone = var.is_public_zone ? "public-zone" : "private-zone"
  vpc_id   = var.is_public_zone ? [] : [var.vpc_id]

  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = true
    },
    var.tags
  )
}

locals {
  is_vpc_required      = var.is_public_zone ? "not_require_vpc_id" : var.vpc_id == "" ? file("If host zone is not public, you have to set vpc_id") : "bypass_vpc_is_filled"
  is_zone_id_not_found = !var.is_create_zone && length(local.zone_id) == 0 ? file(format("Cannot find the zone id with given dns_name: %s and is_public_zone: %s", var.dns_name, var.is_public_zone)) : "found zone_id"
}

locals {
  zone_id = var.is_create_zone ? aws_route53_zone.this[0].zone_id : data.aws_route53_zone.selected_zone[0].zone_id
}
