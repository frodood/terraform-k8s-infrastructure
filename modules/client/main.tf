resource "aws_security_group" "web" {
  name = "web-sg"
  vpc_id = "${var.vpc-id}"

  egress {
       from_port = 0
       to_port = 0
       protocol = "-1"
       cidr_blocks = ["0.0.0.0/0"]
     }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "kube-client-sg"
  }
}


resource "aws_s3_bucket" "bucket" {
  bucket = "${var.s3-bucket-name}"
  acl    = "private"

}

locals {
  config-map-aws-auth-client = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${var.eks-nodes-arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

  kubeconfig-client = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${var.cluster-endpoint}
    certificate-authority-data: ${var.cluster-certificate_authority}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - ${var.cluster_defaults["name"]}
KUBECONFIG
}

locals {
  eks-client-userdata = <<USERDATA
#!/bin/bash -xe
echo "+++++++++++++++Starting exporter+++++++++++++++"
echo "${local.config-map-aws-auth-client}" > /tmp/aws-auth-cm.yaml
echo "${local.kubeconfig-client}" > /tmp/kubeconfig
echo "Done COPY _+++++++++++++++++++++++"
export AWS_ACCESS_KEY_ID="${var.access-id}"
export AWS_SECRET_ACCESS_KEY="${var.access-key}"
echo "DOING AUTH"
kubectl --kubeconfig /tmp/kubeconfig apply -f /tmp/aws-auth-cm.yaml
git clone https://github.com/frodood/web-app-k8s.git
kubectl --kubeconfig /tmp/kubeconfig apply -f web-app-k8s/deployment-manifests/web-frontend-deployment.yaml
kubectl --kubeconfig /tmp/kubeconfig create -f web-app-k8s/deployment-manifests/service-web-frontend-lb.yaml
sleep 10
kubectl --kubeconfig /tmp/kubeconfig get svc -o jsonpath='{.items[*].status.loadBalancer.ingress[*].hostname}' > ELB-FACTS.txt

aws s3 cp ELB-FACTS.txt s3://elk-state-files-"${var.cluster_defaults["name"]}"

USERDATA
}

locals {
  prometheus-userdata = <<USERDATA
#!/bin/bash -xe
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce awscli
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
git clone https://github.com/frodood/web-app-k8s.git
export AWS_ACCESS_KEY_ID="${var.access-id}"
export AWS_SECRET_ACCESS_KEY="${var.access-key}"
aws s3 cp s3://elk-state-files-"${var.cluster_defaults["name"]}" . --recursive
sed -i "s/ELB/$(sed 's:/:\\/:g' ELB-FACTS.txt)/" web-app-k8s/prometheus/config/prometheus/prometheus.yml
sudo docker-compose -f web-app-k8s/prometheus/docker-compose.yml up -d


USERDATA
}

resource "aws_instance" "eks-kube-client" {
  ami           = "${var.client_defaults["ami_id"]}"
  instance_type = "${var.client_defaults["instance_type"]}"
  key_name      = "${var.client_defaults["key_name"]}"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  subnet_id = "${var.subnet-1a-public}"
  user_data_base64            = "${base64encode(local.eks-client-userdata)}"
  associate_public_ip_address = "${var.client_defaults["public_ip"]}"


  tags {
    Name = "kubectl-client"
  }
}

resource "aws_instance" "prometheus-server" {
  ami           = "${var.prometheus_defaults["ami_id"]}"
  instance_type = "${var.prometheus_defaults["instance_type"]}"
  key_name      = "${var.prometheus_defaults["key_name"]}"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  subnet_id = "${var.subnet-1b-public}"
  user_data_base64            = "${base64encode(local.prometheus-userdata)}"
  associate_public_ip_address = "${var.prometheus_defaults["public_ip"]}"
  depends_on = ["aws_instance.eks-kube-client"]

  tags {
    Name = "prometheus-server"
  }
}
