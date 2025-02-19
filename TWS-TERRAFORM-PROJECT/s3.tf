resource "aws_s3_bucket" "mys3bucket" { 
    bucket = "lenproject0441" 
    tags = {
      Name = "projects3bucket"  
    }
}
