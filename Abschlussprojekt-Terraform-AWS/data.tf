data "aws_s3_bucket_object" "config" {
  bucket = "backend-lambdafun-s3"
  key    = "lambdi.json"
}