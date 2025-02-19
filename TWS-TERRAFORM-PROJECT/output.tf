output "mys3bucket" { 
    value = aws_s3_bucket.mys3bucket.id 
  
}

output "myinstanceid" { 
    value = aws_instance.merainstance.id
  
}