# Create Key Pair
resource "aws_key_pair" "merakeypair" { 
  key_name   = "mykeypair" 
  public_key = file("/home/masterserver/.ssh/id_ed25519.pub")
}

# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Create Security Group in Default VPC
resource "aws_security_group" "merasecurity_group" {
  vpc_id = data.aws_vpc.default.id

  # Allow inbound SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MyDefaultVPCSecurityGroup"
  }
}

# Create EC2 Instance
resource "aws_instance" "merainstance" { 
  ami           = "ami-00bb6a80f01f03502"  # ✅ Fixed AMI quotes
  instance_type = "t2.micro"
  key_name      = aws_key_pair.merakeypair.key_name
  subnet_id     = "subnet-0d31af99e6c8dceed"  # ✅ Fixed Subnet ID quotes
  vpc_security_group_ids = [aws_security_group.merasecurity_group.id]  # ✅ Corrected security group reference

  tags = {
    Name = "mera instance"
  }
}
