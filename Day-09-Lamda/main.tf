# Terraform configuration for AWS Lambda function with S3 bucket and CloudWatch event rule
resource "aws_iam_role" "name" {
  name = "lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}
# in this configuration, we define an IAM role for the Lambda function, attach necessary policies for basic execution and S3 read-only access, create the Lambda function itself, set up a CloudWatch event rule to trigger the Lambda every 5 minutes, and create an S3 bucket to store the Lambda code.
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.name.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "s3_read_only" {
  role       = aws_iam_role.name.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

#lambda function configuration
resource "aws_lambda_function" "name" {
  function_name    = "my_lambda_function"
  role             = aws_iam_role.name.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.14"
  s3_bucket        = aws_s3_bucket.name.bucket
  s3_key           = aws_s3_bucket_object.name.key
  source_code_hash = filebase64sha256("lambda_function.zip")
}

#rule to trigger lambda function every 5 minutes

resource "aws_cloudwatch_event_rule" "name" {
  name                = "my_event_rule111"
  description         = "Trigger Lambda every 5 minutes"
  schedule_expression = "cron(0/5 * * * ? *)"
}
# target to link the CloudWatch event rule to the Lambda function
resource "aws_cloudwatch_event_target" "name" {
  rule      = aws_cloudwatch_event_rule.name.name
  target_id = "my_lambda_target111"
  arn       = aws_lambda_function.name.arn
}
# permission to allow CloudWatch to invoke the Lambda function
resource "aws_lambda_permission" "name" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.name.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.name.arn
}

# S3 bucket to store the Lambda code
resource "aws_s3_bucket" "name" {
  bucket = "my-lambda-code-bucket-1234567890"
  acl    = "private"
  tags = {
    Name = "LambdaCodeBucket11111"
  }
}

#object to upload the Lambda code to the S3 bucket
resource "aws_s3_bucket_object" "name" {
  bucket = aws_s3_bucket.name.bucket
  key    = "lambda/lambda_function.zip"
  source = "lambda_function.zip"
  etag   = filemd5("lambda_function.zip")
}
