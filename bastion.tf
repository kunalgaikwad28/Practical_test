# Reference existing resources using data sources
data "aws_subnet" "bastion_subnet" {
  id = "subnet-0b8df1ddf873f6712"  # Existing public subnet ID
}

data "aws_security_group" "bastion_sg" {
  id = "sg-0dd7311c01a0a323e"  # Existing security group ID for SSH
}

# ✅ Removed duplicate aws_vpc "selected"

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

# Create the Bastion host instance
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.bastion_subnet.id
  vpc_security_group_ids      = [data.aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = "sg"  # Replace with your actual key pair name

  tags = {
    Name = "bastion-host"
  }
}

# Output public IP and SSH command
output "bastion_public_ip" {
  description = "Public IP of the Bastion host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_connection_command" {
  description = "SSH command to connect to the Bastion host"
  value       = "ssh -i ~/.ssh/my_key_pair.pem ec2-user@${aws_instance.bastion.public_ip}"
}

