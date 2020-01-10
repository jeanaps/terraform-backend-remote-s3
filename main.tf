provider "aws" {
  region = "us-west-2" # Definir região que vai ser usada pra criação das instancias
}

resource "aws_s3_bucket" "artfacts" {
  bucket = "${var.PROJECT-NAME}-terraform"
  #bucket = var.environment == "production" ? var.PROJECT-NAME : format("${var.PROJECT-NAME}-%s", var.environment)
  acl    = "private"
  versioning {
    enabled = "true"
  }
  tags = {
    Project = var.PROJECT-NAME
    Environment = var.environment
  }
}

resource "aws_s3_bucket_object" "folder-environment" {
    bucket = aws_s3_bucket.artfacts.id
    acl    = "private"
    key    = "/${var.environment}-tfstate/${var.environment}.tfstate"
    source = "/dev/null"
}


resource "aws_s3_bucket_policy" "artfacts" {
  bucket = aws_s3_bucket.artfacts.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "RequireEncryption",
   "Statement": [
    {
      "Sid": "RequireEncryptedTransport",
      "Effect": "Deny",
      "Action": ["s3:*"],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.artfacts.bucket}/*"],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      },
      "Principal": "*"
    },
    {
      "Sid": "RequireEncryptedStorage",
      "Effect": "Deny",
      "Action": ["s3:PutObject"],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.artfacts.bucket}/*"],
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "AES256"
        }
      },
      "Principal": "*"
    }
  ]
}
EOF
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "${var.PROJECT-NAME}-${var.environment}-terraformstate"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


#terraform {
#    backend "s3" {
#        bucket = "newlab-artfacts"
#        key = "s3backend.tfstate"
#        region = "us-west-2"
#        encrypt = true
#        dynamodb_table = "terraform_state_lock" 
#
#    }
#}