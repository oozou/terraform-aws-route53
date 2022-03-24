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

/* -------------------------------------------------------------------------- */
/*                                 Hostxedzone                                */
/* -------------------------------------------------------------------------- */
/* -------------------------------- Host zone ------------------------------- */
resource "aws_route53_zone" "this" {
  count = var.is_create_zone ? 1 : 0

  name = var.dns_name

  dynamic "vpc" {
    for_each = local.vpc_id
    content {
      vpc_id = vpc.value
    }
  }

  tags = merge(
    local.tags,
    { "Name" = format("%s-%s", local.name, local.hostzone) }
  )
}
/* --------------------------------- Record --------------------------------- */
data "aws_route53_zone" "selected_zone" {
  count = var.is_create_zone ? 0 : 1

  name         = var.dns_name
  private_zone = !var.is_public_zone
}

locals {
  zone_id = var.is_create_zone ? aws_route53_zone.this[0].zone_id : data.aws_route53_zone.selected_zone[0].zone_id
}

resource "aws_route53_record" "this" {
  for_each = var.dns_records

  zone_id         = local.zone_id
  name            = format("%s%s", lookup(each.value, "name", ""), lookup(each.value, "name", null) == null ? "" : format(".%s", var.dns_name))
  type            = lookup(each.value, "type", null)
  allow_overwrite = lookup(each.value, "allow_overwrite", false)
  ttl             = lookup(each.value, "ttl", null)
  records         = lookup(each.value, "records", null)

  dynamic "alias" {
    for_each = length(keys(lookup(each.value, "alias", {}))) == 0 ? [] : [true]

    content {
      name                   = each.value.alias.name
      zone_id                = try(each.value.alias.zone_id, local.zone_id)
      evaluate_target_health = lookup(each.value.alias, "evaluate_target_health", false)
    }
  }
}