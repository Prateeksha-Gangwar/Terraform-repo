resource "aws_iam_user" "user" {

  name = var.user_name

  tags = {
    Name = var.user_name
  }
}


resource "aws_iam_user_policy_attachment" "policy" {

  user = aws_iam_user.user.name

  policy_arn = var.policy_arn
}


resource "aws_iam_access_key" "key" {

  user = aws_iam_user.user.name

}