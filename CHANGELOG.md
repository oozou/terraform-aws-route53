# Change Log

All notable changes to this module will be documented in this file.

## [1.0.3] - 2022-07-29

### Added

- Add variable `var.is_ignore_vpc_changes` to decide which host zone to use
    - Add resource `aws_route53_zone.this_ignore_vpc` for integration with private zone route association
- Add local variables `local.zone_name` using at outputs.tf

### Changed

- Move all locals into main.tf
- Move usage in README to examples/simple folder
- Update `local.zone_id` condition when use with variables `var.is_ignore_vpc_changes`
- Output result support multiple resource creation

## [1.0.2] - 2022-07-20

### Added

- Examples
- CHANGELOG.md

## [1.0.1] - 2022-05-12

### Updated

- README.md
- move local to main.tf to local.tf

## [1.0.0] - 2022-03-30

### Added

- Initial release for terraform-aws-route53 module
- add hostzone + dynamic record with alias
- add only record craete
