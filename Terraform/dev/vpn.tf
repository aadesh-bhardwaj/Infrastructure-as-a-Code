#pritunl ec2 instance
module "pritunl" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "Aadesh-Pritunl-Host"

  ami                    = "ami-0530ca8899fac469f"
  instance_type          = local.instance_type
  key_name               = local.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.pritunl-sg.id]
  subnet_id              = element(module.vpc.public_subnets, 0)

  user_data = file("pritunl.sh")
  tags = {
    Terraform   = "true"
    Environment = "stg"
  }
}

#security group for pritunl
resource "aws_security_group" "pritunl-sg" {
  name   = "Pritunl-SG"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "Aadesh-Pritunl-SG"
    Owner = "Aadesh"
  }
}