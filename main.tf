provider "aws" {
  region = "us-east-1"
}

# 1. Create an SNS Topic
resource "aws_sns_topic" "ec2_alerts" {
  name = "ec2-state-change-alerts"
}

# 2. Subscribe your email to the topic
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.ec2_alerts.arn
  protocol  = "email"
  endpoint = "wanjicloudk@gmail.com" 
}

# 3. Create a CloudWatch Event Rule for EC2 State Changes
resource "aws_cloudwatch_event_rule" "ec2_state_rule" {
  name        = "monitor-ec2-state-change"
  description = "Detects when any EC2 instance changes state"
  
  event_pattern = jsonencode({
    "source"      : ["aws.ec2"],
    "detail-type" : ["EC2 Instance State-change Notification"]
  })
}


# 4. Set SNS as the Target for the Rule
resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.ec2_state_rule.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.ec2_alerts.arn
}

# 5. Allow CloudWatch to publish to your SNS Topic
resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.ec2_alerts.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    actions   = ["SNS:Publish"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    resources = [aws_sns_topic.ec2_alerts.arn]
  }
}

# 6. A basic EC2 Instance to monitor
resource "aws_instance" "monitor_me" {
  ami           = "ami-0e349888043265b96" # (Verify for your region)
  instance_type = "t3.micro"

  tags = { Name = "Challenge-EC2Monitor" }
}

output "instance_id" {
  value = aws_instance.monitor_me.id
}
