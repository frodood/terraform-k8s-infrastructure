resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc["main"]}"

  tags = "${
    map(
     "Name", "${var.env}-vpc",
     "Environment", "${var.env}",
     "kubernetes.io/cluster/${var.cluster_defaults["name"]}", "shared"
    )
  }"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.env}-igw"
    Environment = "${var.env}"
  }
}


resource "aws_subnet" "subnet-1a-public" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.vpc["subnet-1a-public"]}"
  availability_zone = "${var.region}a"

  tags = "${
    map(
     "Name", "${var.env}-rt-1a-public",
     "Environment", "${var.env}"
    )
  }"

}

resource "aws_route_table" "rt-1a-public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name        = "${var.env}-rt-1a-public"
    Environment = "${var.env}"
  }
}

resource "aws_route_table_association" "rt-1a-public" {
  subnet_id      = "${aws_subnet.subnet-1a-public.id}"
  route_table_id = "${aws_route_table.rt-1a-public.id}"
}

resource "aws_subnet" "subnet-1b-public" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.vpc["subnet-1b-public"]}"
  availability_zone = "${var.region}b"

  tags = "${
    map(
     "Name", "${var.env}-rt-1b-public",
     "Environment", "${var.env}"
    )
  }"
}

resource "aws_route_table" "subnet-1b-public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name        = "${var.env}-rt-1b-public"
    Environment = "${var.env}"
  }
}

resource "aws_route_table_association" "subnet-1b-public" {
  subnet_id      = "${aws_subnet.subnet-1b-public.id}"
  route_table_id = "${aws_route_table.subnet-1b-public.id}"
}
