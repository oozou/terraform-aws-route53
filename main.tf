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
  is_vpc_required = var.is_public_zone ? "not_require_vpc_id" : var.vpc_id == "" ? file("If host zone is not public, you have to set vpc_id") : "bypass_vpc_is_filled"
}

/* -------------------------------------------------------------------------- */
/*                                 Hostxedzone                                */
/* -------------------------------------------------------------------------- */
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

resource "aws_route53_record" "this" {
  for_each = var.is_create_zone ? var.dns_records : null

  zone_id = aws_route53_zone.this[0].zone_id

  name            = format("%s%s", lookup(each.value, "name", ""), lookup(each.value, "name", null) == null ? "" : format(".%s", var.dns_name))
  type            = lookup(each.value, "type", null)
  allow_overwrite = lookup(each.value, "allow_overwrite", false)

  ttl     = lookup(each.value, "ttl", null)
  records = lookup(each.value, "records", null)

  dynamic "alias" {
    for_each = length(keys(lookup(each.value, "alias", {}))) == 0 ? [] : [true]

    content {
      name                   = each.value.alias.name
      zone_id                = try(each.value.alias.zone_id, aws_route53_zone.this[0].zone_id)
      evaluate_target_health = lookup(each.value.alias, "evaluate_target_health", false)
    }
  }
}
