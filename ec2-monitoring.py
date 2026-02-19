import boto3

# Initialize the EC2 client
ec2 = boto3.client('ec2', region_name='us-east-1')

# Replace with the instance_id from your Terraform output
INSTANCE_ID = "i-0d817f873ae20a851" 

def stop_instance(id):
    print(f"Stopping instance: {id}...")
    ec2.stop_instances(InstanceIds=[id])
    print("Change request sent to Wanji. Plese check your email for the CloudWatch alert!")

if __name__ == "__main__":
    stop_instance("i-0d817f873ae20a851")