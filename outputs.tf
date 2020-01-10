output "Bucket-Project" {
  value = "${aws_s3_bucket.artfacts.id}"
  description = "Bucket of Project"
}

output "Folder-environment" {
  value = "${aws_s3_bucket_object.folder-environment.id}"
  description = "Folder of Environment"
}
