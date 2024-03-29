resource "aws_autoscaling_group" "project_asg" {
  name                 = "project-asg"
  max_size             = 3
  min_size             = 1
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.project_lt.name
  vpc_zone_identifier  = var.subnets
  target_group_arns    = [var.target_group_arn]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "project_lt" {
  name            = "project-lt"
  image_id        = "ami-0d191274f098564a6" # GoldenAMI vom Ansible-Team
  instance_type   = "t2.micro"              # FreeTier
  security_groups = [var.security_groups]
  key_name        = var.key_name

  lifecycle {
    create_before_destroy = true
  }

  # hier muss der finale DockerContainerImage-Name eingetragen werden hinter "docker run"
  user_data = <<-EOF
                #!/bin/bash
                docker login --username aws2302 --password "${var.docker_pass}"
                docker run --name frontend -d -p 80:80 -i aws2302/aws2302:latest
                EOF
}
