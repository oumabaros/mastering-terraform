data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "frontend" {
  most_recent = true
  owners      = ["self"] # Use 'self' or similar to filter for your local AMI
  filter {
    name   = "name"
    values = ["frontend-ami"]
  }
  filter {
    name   = "image-id"
    values = ["ami-000001"] # Explicitly reference the AMI ID you created
  }
}

data "aws_ami" "backend" {
  most_recent = true
  owners      = ["self"] # Use 'self' or similar to filter for your local AMI
  filter {
    name   = "name"
    values = ["backend-ami"]
  }
  filter {
    name   = "image-id"
    values = ["ami-000002"] # Explicitly reference the AMI ID you created
  }
}

# Define a data source to look up an existing key pair by its name
data "aws_key_pair" "main" {
  key_name = "ec2_vm_manager" # The name of the existing key in AWS
}

data "cloudinit_config" "frontend" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/files/setup.sh")
  }
}
