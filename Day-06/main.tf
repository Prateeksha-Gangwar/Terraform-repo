resource "aws_iam_user" "name" {
  name = "Cloud-Computing-User"
}
resource "aws_iam_access_key" "name" {
  user = aws_iam_user.name.name
}
resource "aws_iam_user_login_profile" "name" {
  user    = aws_iam_user.name.name
  pgp_key = "keybase:username"
}