resource "aws_instance" "devops_ec2" {
  ami           = "ami-0354c98ae10b02961"
  instance_type = "t2.micro"

  tags = {
    Name = "Jenkins-CICD-EC2"
  }
}
