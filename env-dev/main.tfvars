env = "dev"

project_name = "expense"

vpc = {
  main = {
    vpc_cidr = "10.10.0.0/21"
    subnets_cidr = ["10.10.0.0/25", "10.10.0.128/25"]
    az = ["us-east-1a", "us-east-1b"]
  }
}