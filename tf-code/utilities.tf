# The cidrsubnet function in Terraform calculates a specific subnet address from a 
# larger IP range. Its syntax is cidrsubnet(prefix, newbits, netnum)
# > cidrsubnet("192.168.1.0/24", 2, 0)
# "192.168.1.0/26"
# > cidrsubnet("192.168.1.0/24", 2, 1)
# "192.168.1.64/26"
# > cidrsubnet("192.168.1.0/24", 2, 2)
# "192.168.1.128/26"
# > cidrsubnet("192.168.1.0/24", 2, 3)
# "192.168.1.192/26"
# netnum 0, 1, 2, and 3 select the first, second, third, and fourth possible /26 subnets, respectively.
# Splitting a /16 into /24 subnets: You add 8 new bits (16 + 8 = 24).
# > cidrsubnet("10.0.0.0/16", 8, 0)
# "10.0.0.0/24"
# > cidrsubnet("10.0.0.0/16", 8, 1)
# "10.0.1.0/24"
# > cidrsubnet("10.0.0.0/16", 8, 2)
# "10.0.2.0/24"

locals {
  azs_random = random_shuffle.az.result

  public_subnets = { for k, v in local.azs_random :
    k => {
      cidr_block        = cidrsubnet(var.vpc_cidr_block, var.cidr_split_bits, k)
      availability_zone = v
    }
  }
  private_subnets = { for k, v in local.azs_random :
    k => {
      cidr_block        = cidrsubnet(var.vpc_cidr_block, var.cidr_split_bits, k + var.az_count)
      availability_zone = v
    }
  }
}

#Generate a random permutation of a list of strings
# Define a variable with a list of values
# variable "all_regions" {
#   type    = list(string)
#   default = ["us-east-1", "us-west-2", "eu-west-1", "eu-central-1"]
# }

# # Shuffle the list and select a random subset
# resource "random_shuffle" "deployment_regions" {
#   input        = var.all_regions
#   result_count = 2 # Selects 2 random regions
# }

# # Output the selected regions
# output "selected_regions" {
#   value = random_shuffle.deployment_regions.result
#   description = "The randomly selected regions for deployment"
# }
resource "random_shuffle" "az" {
  input        = data.aws_availability_zones.available.names
  result_count = var.az_count
}
