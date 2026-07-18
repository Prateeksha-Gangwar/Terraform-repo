resource "aws_iam_user" "example" {
  name = "Pratu-User"

}
resource "aws_iam_group" "name" {
    name = "Tester" 
}

resource "aws_iam_policy" "ec2_policy" {
  name        = "Ec222222222"
  description = "EC2 Full Access Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "EC2FullAccess"
        Effect   = "Allow"
        Action   = "ec2:*"
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to IAM User
resource "aws_iam_user_policy_attachment" "attach_ec2_policy" {
  user       = aws_iam_user.example.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}