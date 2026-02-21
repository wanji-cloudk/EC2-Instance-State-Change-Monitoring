## CHALLENGE 1

## Company XYZ requires real-time notifications whenever an EC2 instance changes its operational state.

Here is my step-by-step cloud architecture solution i implemented entirely in Python using the boto3 AWS SDK.

The Solution uses three core AWS services working together: Amazon EC2 to host the monitored instance, Amazon SNS to deliver email notifications, and Amazon EventBridge to detect and route state-change events automatically

## Prerequisites
	Python 3.8 or higher installed
	boto3 installed:  pip install boto3
	AWS CLI configured with credentials:  aws configure
	IAM user with EC2, SNS, EventBridge and IAM permissions
	A valid email address to receive SNS alerts

## Setup 
1, Install dependancies:
```bash
pip install boto3

2, Install Terraform
wget https://releases.hashicorp.com/terraform/1.7.0/terraform_1.7.0_linux_amd64.zip

##Unzip the file:
bashunzip terraform_1.7.0_linux_amd64.zip

## Move it to your PATH:
```bash
sudo mv terraform /usr/local/bin/

##NB use below command if you have already install terraform
Download from terraform.io/downloads

3, Download the aws installer:
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

## Unzip it:
unzip awscliv2.zip

##Install it:
sudo ./aws/install

##Verify
aws --version

## Make sure you sign up at aws.amazon.com

4,aws configure credetials:

```bash
aws configure



  AWS Access Key ID:      - your key
  AWS Secret Access Key:  - your secret
  Default region name:    us-east-1
  Default output format:  - press Enter

## Setup & Deployment

## Clone the repository:
bashgit clone https://github.com/your-username/EC2-Instance-State-Change-Monitoring.git
cd EC2-Instance-State-Change-Monitoring/ec2-monitoring

## Files and what they do:

Terraform (`main.tf`) This file sets up our EC2 instance, the SNS topic for alerts, and the CloudWatch Event Rule that "listens" for EC2 state changes

Boto3 (`upload.py`) Instead of using the AWS Console, i used this Python script to stop the instance. This will trigger the CloudWatch Event Rule i just built

## Verify your AMI ID
Get a valid Amazon Linux 2 AMI for us-east-1:
bashaws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" \
  --query "sort_by(Images, &CreationDate)[-1].ImageId" \
  --output text \
  --region us-east-1
Type yes when prompted. Copy the instance_id from the output.
Update the ami value in main.tf with the result.

## Deploy with Terraform
```bash
terraform init
terraform plan
terraform apply
```

![Terraform Apply](https://raw.githubusercontent.com/wanji-cloudk/EC2-Instance-State-Change-Monitoring/main/terraform%20apply.png)

## Confirm your SNS subscription
Check your email inbox for an AWS Notification - Subscription Confirmation message and click Confirm subscription. Without this step, alerts will not be delivered.

## Run the test script
Update INSTANCE_ID in ec2-monitoring.py with your instance ID, then run:
```bash
python3 ec2-monitoring.py

## Check your email
Within 60 seconds you should receive a JSON email alert showing the instance state changed to stopping and stopped.







