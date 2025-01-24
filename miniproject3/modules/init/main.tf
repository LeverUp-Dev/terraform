# 레포지토리 생성
resource "aws_ecr_repository" "cicd" {
  name                 = "cicd"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# IAM 역할 생성
resource "aws_iam_role" "AWSCodeDeployRoleForECS" {
  name = "AWSCodeDeployRoleForECS"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = [
            "ecs-tasks.amazonaws.com"
          ]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.AWSCodeDeployRoleForECS.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS 구성
# 1. 클러스터
resource "aws_ecs_cluster" "cicdCluster" {
  name = "cicdCluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# 2. 태스크
resource "aws_ecs_task_definition" "cicd" {
  family                   = "cicd"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  
  execution_role_arn = aws_iam_role.AWSCodeDeployRoleForECS.arn

  track_latest = true

  container_definitions    = jsonencode([{
    name  = "cicd-container"
    image = "${aws_ecr_repository.cicd.repository_url}:latest"
    portMappings = [{
      containerPort = 8082
      hostPort      = 8082
      protocol      = "tcp"
    }]
  }])
}

# 3. 네트워크 설정 및 서비스
resource "aws_security_group" "ecs_service" {
  name        = "ecs_service"
  description = "Allow TCP/5000 inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ecs_service"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs_service_5000" {
  security_group_id = aws_security_group.ecs_service.id

  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 8082
  ip_protocol                  = "tcp"
  to_port                      = 8082
}

resource "aws_vpc_security_group_egress_rule" "ecs_service" {
  security_group_id = aws_security_group.ecs_service.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "alb" {
  name        = "alb"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "alb"
  }
}

  # ALB 보안그룹 생성
resource "aws_security_group" "alb_SG" {
  name        = "alb_SG"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "alb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_80" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Target Group
resource "aws_lb_target_group" "alb_tg" {
  name     = "alb-tg"
  port     = 8082
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "ip"

  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }
}

# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.vpc_public_subnets
}

# ALB Listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_ecs_service" "cicdService" {
  name            = "cicdService"
  cluster         = aws_ecs_cluster.cicdCluster.id
  task_definition = aws_ecs_task_definition.cicd.id
  launch_type = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = var.vpc_public_subnets
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    container_name   = "cicd-container"
    container_port   = 8082
  }
}
