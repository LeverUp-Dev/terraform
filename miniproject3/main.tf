# VPC 생성
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "cicd-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["us-east-2a", "us-east-2c"]
  public_subnets = ["10.0.0.0/24", "10.0.1.0/24"]

  map_public_ip_on_launch = true
}

module "my_init" {
  source = "./modules/init"
  vpc_id = module.vpc.vpc_id
  vpc_public_subnets = module.vpc.public_subnets
}

module "my_codebuild" {
  source = "./modules/codebuild"
  aws_region = var.region
}

module "my_codepipeline" {
  source = "./modules/codepipeline"
  github_repo_name = var.github_repo_name
  codebuild_name = module.my_codebuild.codebuild_name
  ecs_cluster_name = module.my_init.ecs_cluster_name
  ecs_service_name = module.my_init.ecs_service_name
  aws_region = var.region
}
