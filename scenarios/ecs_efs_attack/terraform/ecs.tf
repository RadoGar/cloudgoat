resource "aws_ecs_cluster" "cg-cluster" {
  name = "cg-cluster-${var.cgid}"
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "db59612d-f27d-414d-9893-9b081fb916fb"
    Owner     = "RGA"
  }
}


resource "aws_ecs_task_definition" "cg-webapp" {
  family                   = "webapp"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = "${aws_iam_role.cg-ecs-role.arn}"
  execution_role_arn       = "${aws_iam_role.cg-ecs-role.arn}"

  container_definitions = <<DEFINITION
[
  {
    "cpu": 128,
    "command": [
            "/bin/sh -c \"echo '<html> <head> <title>CloudGoat EC2 </title> <style>body {margin-top: 40px; background-color: #333;} </style> </head><body> <div style=color:white;text-align:center> <h1>CloudGoat ...</h1> <h2>Welcome!</h2> </div></body></html>' >  /usr/local/apache2/htdocs/index.html && httpd-foreground\""
         ],
         "entryPoint": [
            "sh",
            "-c"
         ],
    "essential": true,
    "image": "httpd:2.4",
    "memory": 128,
    "memoryReservation": 64,
    "name": "webapp",
    "portMappings": [ 
            { 
               "containerPort": 80,
               "hostPort": 80,
               "protocol": "tcp"
            }
         ]
  }
]
DEFINITION
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "df762565-a323-4b2b-98db-65e8ade01ad3"
    Owner     = "RGA"
  }
}


data "aws_ecs_task_definition" "cg-webapp" {
  task_definition = "${aws_ecs_task_definition.cg-webapp.family}"
}

resource "aws_ecs_service" "cg-webapp" {
  name          = "cg-webapp-${var.cgid}"
  cluster       = "${aws_ecs_cluster.cg-cluster.name}"
  desired_count = 1
  launch_type   = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.cg-ecs-http-security-group.id]
    subnets          = ["${aws_subnet.cg-public-subnet-1.id}"]
    assign_public_ip = true
  }

  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.cg-webapp.family}:${max("${aws_ecs_task_definition.cg-webapp.revision}", "${data.aws_ecs_task_definition.cg-webapp.revision}")}"
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "8116b908-df93-45bd-9949-ad215e6f24cd"
    Owner     = "RGA"
  }
}


resource "aws_iam_policy_attachment" "cg-ecs-role-policy-attachment" {
  name = "cg-ecs-role-policy-attachment-${var.cgid}"
  roles = [
    "${aws_iam_role.cg-ecs-role.name}"
  ]
  policy_arn = "${aws_iam_policy.cg-ecs-role-policy.arn}"
}


resource "aws_security_group" "cg-ecs-http-security-group" {
  name        = "cg-ecs-http-${var.cgid}"
  description = "CloudGoat ${var.cgid} Security Group for ecs"
  vpc_id      = "${aws_vpc.cg-vpc.id}"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.cg_whitelist
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name      = "cg-ecs-http-${var.cgid}"
    Stack     = "${var.stack-name}"
    Scenario  = "${var.scenario-name}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "0a17e82b-807e-4cea-9003-2a39e05a01b7"
    Owner     = "RGA"
  }
}