# Existing Subnet fetch karo (Data Block)
data "aws_subnet" "name" {
  filter {
    name   = "tag:Name"
    values = ["my-subnet"]   # ← apna subnet name do
  }
}

# EC2 Instance
resource "aws_instance" "name" {
  ami           = "ami-01edba92f9036f76e"
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.name.id   # ← data block se subnet ID lo

  tags = {
    Name = "my-ec2-instance"
  }
}

