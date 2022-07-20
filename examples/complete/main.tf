provider "aws" {
  region = "us-east-2"
}

module "host_zone_and_record" {
  source = "../.."

  is_create_zone = true
  is_public_zone = false             # Default `true`
  vpc_id         = "vpc-xxxxxx" # If is_public_zone is `true`, no need to specific

  prefix      = "oozou"
  environment = "dev"

  dns_name = "oozou-test"
  dns_records = {
    oozou_alias = {
      name = "app1.domain"
      type = "A"
      alias = {
        name    = "oozou-internal-alb-xxxxx.us-east-2.elb.amazonaws.com" # Target DNS name
        zone_id = "xxxxxxx"
      }
    }
  }

  tags = { "Workspace" = "O-labtop" }
}
  
module "only_record" {
  source = "../.."
  depends_on = [module.host_zone_and_record]
  is_create_zone = false
  is_public_zone = false             # Default `true`
  vpc_id         = "vpc-xxxxxxx" # If is_public_zone is `true`, no need to specific

  prefix      = "oozou"
  environment = "dev"

  dns_name = "oozou-test"

  dns_records = {
    test_dns = {
      name    = "app2.domain"
      type    = "A"
      ttl     = "5"
      records = ["192.112.112.112", "192.112.112.113"]
    }
  }
}
