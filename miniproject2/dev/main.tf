provider "aws" {
  region = "ap-northeast-2"
}

module "my_vpc" {
  source = "../modules/vpc"
}

module "my_asg" {
  source = "../modules/asg"
  vpc_id = module.my_vpc.vpc_id
  db_address = module.my_db.db_address
  db_username = var.db_username
  db_password = var.db_password
  target_group_arns = [module.my_alb.target_group_arn]
  vpc_zone_identifier = module.my_vpc.public_subnets_ids

  depends_on = [ module.my_vpc, module.my_alb, module.my_db ]
}

module "my_alb" {
  source = "../modules/alb"
  vpc_id = module.my_vpc.vpc_id
  subnets = module.my_vpc.public_subnets_ids
}

module "my_db" {
  source = "../modules/db"
  vpc_id = module.my_vpc.vpc_id
  subnet_ids = module.my_vpc.subnets_ids
  db_username = var.db_username
  db_password = var.db_password
}
