// this is extra 
// we have created beantstalk enviroment, but to upload artifact you should go to aws and select our app then upload our artifact 
// solution
// create  s3 bucket upload push file to it  define or (edit)  beanstalk application and update beanstalk env. 


# resource "aws_s3_bucket" "artifact_bucket" {
#   bucket = "your-artifact-bucket-name"
# }


# resource "aws_s3_object" "artifact" {
#   bucket = aws_s3_bucket.artifact_bucket.bucket
#   key    = "your-app-artifact.zip"
#   source = "path/to/your-artifact.zip"
#   acl    = "private"
# }

#                //  put this section  this at bean-vprofile.tf
# resource "aws_elastic_beanstalk_application_version" "app_version" {
#   name =  "vprofile-prod" 
#   application = aws_elastic_beanstalk_application.vprofile-prod.name
#   bucket = aws_s3_bucket.artifact_bucket.bucket
#   key    = aws_s3_object.artifact.key
# }

