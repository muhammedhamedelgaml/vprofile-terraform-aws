// we will create s3 bucket to store the state file (centralize)
// we created at aws s3 bucket name "vprofile-terra-state"  then create folder name "terraform"

terraform {
  backend "s3" {
      bucket = "vprofile-terra-state"
      key    = "terraform/statefile"
      region = "us-east-2"

  }
}