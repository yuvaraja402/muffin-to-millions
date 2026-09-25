resource "aws_route53_zone" "main" {
  name = "ynygma.online"
}


resource "aws_route53_record" "apex" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "ynygma.online"
  type    = "A"

  alias {
    name                   = "k8s-default-mymicros-5d899dda70-623b264cda8f464c.elb.ca-central-1.amazonaws.com"
    zone_id                = "Z2EPGBW3API2WT"
    evaluate_target_health = true
  }
}

output "route53_nameservers" {
  value = aws_route53_zone.main.name_servers
}


