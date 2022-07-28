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

  # The aws_route53_zone vpc argument accepts multiple configuration blocks.
  # The below usage of the single vpc configuration, the
  # lifecycle configuration, and the aws_route53_zone_association
  # resource is for illustrative purposes (e.g., for a separate
  # cross-account authorization process, which is not shown here).
  lifecycle {
    ignore_changes = [vpc]
  }

  tags = merge(local.tags, { "Name" = format("%s-%s", local.name, local.hostzone) })
}
/* --------------------------------- Record --------------------------------- */
data "aws_route53_zone" "selected_zone" {
  count = var.is_create_zone ? 0 : 1

  name         = var.dns_name
  private_zone = !var.is_public_zone
}

resource "aws_route53_record" "this" {
  for_each = var.dns_records

  zone_id         = local.zone_id
  name            = lookup(each.value, "name", "") == "" ? format("%s", var.dns_name) : format("%s.%s", lookup(each.value, "name", ""), var.dns_name)
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
