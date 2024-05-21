provider "aws" {
  region = "us-east-1"
}

resource "aws_sns_topic" "my_topic" {
  name = "my-sns-topic"
}

resource "aws_sqs_queue" "my_queue" {
  name = "my-sqs-queue"
}

resource "aws_sns_topic_subscription" "sns_to_sqs" {
  topic_arn = aws_sns_topic.my_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.my_queue.arn
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_policy" {
  name        = "ec2-policy"
  description = "EC2 policy to interact with SNS, SQS, and S3"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "sns:Publish",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "s3:PutObject",
          "s3:GetObject"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_instance" "server_a" {
  ami           = "ami-04ff98ccbfa41c9ad "
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python3
              pip3 install boto3
              EOF
}

resource "aws_instance" "server_b" {
  ami           = "ami-04ff98ccbfa41c9ad "
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python3
              pip3 install boto3
              EOF
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "question2-s3" 
}