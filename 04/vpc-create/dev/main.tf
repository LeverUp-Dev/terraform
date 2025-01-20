module "my_vpc" {
  source = "../modules/vpc"
  vpc_id = "192.168.0.0/24"
  vpc_subnet = "192.168.0.0/25"
}

module "my_ec2" {
  source = "../modules/ec2"
  subnet_id = module.my_vpc.mysubnet_id
}
