# terraform-aws-route53

## Usage

```terraform
resource "aws_elb" "this" {
  name    = "foobar-terraform-elb"
  subnets = module.vpc.public_subnets_ids

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

module "this" {
  source = "<source>"

  is_public_zone = false  # default true
  vpc_id         = module.vpc.vpc_id # If public zone is `false`, you have to specific vpc_id

  prefix      = "oozou"
  environment = "dev"
  dns_name    = "big.work"
  dns_records = {
    art_dns = {
      name    = "art.r" # Auto append with dns_name -> art.r.big.work
      type    = "A"
      ttl     = "5"
      records = ["192.112.112.112", "192.112.112.113"]
    }
    big_dns = {
      name    = "big.k" # Auto append with dns_name -> m.s.big.work
      type    = "A"
      ttl     = "5"
      records = ["56.56.56.56", "56.56.56.58"]
    }
    art_alias = {
      name = "art.ah.ah.alias.domain" # Up tp use case
      type = "A"
      alias = {
        name    = aws_elb.this.dns_name
        zone_id = aws_elb.this.zone_id
      }
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | >= 4.00  |

## Providers

| Name                                              | Version |
|---------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.00 |

## Modules

No modules.

## Resources

| Name                                                                                                                  | Type     |
|-----------------------------------------------------------------------------------------------------------------------|----------|
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone)     | resource |

## Inputs

| Name                                                                             | Description                                                                          | Type          | Default | Required |
|----------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|---------------|---------|:--------:|
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name)                     | (Required) This is the name of the hosted zone.                                      | `string`      | n/a     |   yes    |
| <a name="input_dns_records"></a> [dns\_records](#input\_dns\_records)            | Map of DNS records                                                                   | `any`         | `{}`    |    no    |
| <a name="input_environment"></a> [environment](#input\_environment)              | Environment Variable used as a prefix                                                | `string`      | n/a     |   yes    |
| <a name="input_is_create_zone"></a> [is\_create\_zone](#input\_is\_create\_zone) | Wherther to create a zone or not                                                     | `bool`        | `true`  |    no    |
| <a name="input_is_public_zone"></a> [is\_public\_zone](#input\_is\_public\_zone) | Wherther to create a zone or not                                                     | `bool`        | `true`  |    no    |
| <a name="input_prefix"></a> [prefix](#input\_prefix)                             | The prefix name of customer to be displayed in AWS console and resource              | `string`      | n/a     |   yes    |
| <a name="input_tags"></a> [tags](#input\_tags)                                   | Tags to add more; default tags contian {terraform=true, environment=var.environment} | `map(string)` | `{}`    |    no    |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id)                           | Required when hostzone is private, to associate with VPC                             | `string`      | `""`    |    no    |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
