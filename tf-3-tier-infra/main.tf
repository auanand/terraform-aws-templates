provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source             = "git::https://github.com/auanand/terraform-aws-module.git//modules/vpc/aws-vpc-3-tier?ref=v1.2"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["ap-south-1a", "ap-south-1b"]
  environment        = "dev"
  customer           = "lup"
  product            = "webapp"
  subnet_cidrs = {
    dmz_a = "10.0.1.0/24"
    dmz_b = "10.0.2.0/24"
    app_a = "10.0.3.0/24"
    app_b = "10.0.4.0/24"
    db_a  = "10.0.5.0/24"
    db_b  = "10.0.6.0/24"
  }
}

module "ec2_instance_jumpserver" {
  source         = "git::https://github.com/auanand/terraform-aws-module.git//modules/ec2?ref=v1.2"
  instance_count = 1
  ami_id         = "ami-01376101673c89611"
  instance_type  = "t2.micro"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = [module.vpc.dmz_subnet_ids[0]]
  instance_name  = "jumpserver"
  customer       = "dev"
  product        = "webapp"
  environment    = "dev"
  security_group_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  data_ebs_volume       = false
  data_volume_size      = 10
  elastic_ip_attachment = true
  depends_on = [module.vpc]
}