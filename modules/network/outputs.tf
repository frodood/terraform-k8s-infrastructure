output "vpcid" {
  value = "${aws_vpc.vpc.id}"
}

output "PublicSubnets" {
  value = ["${aws_subnet.subnet-1a-public.id}","${aws_subnet.subnet-1b-public.id}"]
}

output "SubnetAPublic"{
  value = "${aws_subnet.subnet-1a-public.id}"
}

output "SubnetBPublic"{
  value = "${aws_subnet.subnet-1b-public.id}"
}
