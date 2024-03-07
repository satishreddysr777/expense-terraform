module "vpc" {
  source               = "./modules/vpc"
  for_each             = var.vpc
  vpc_cidr             = lookup(each.value, "vpc_cidr", null)
  public_subnets_cidr  = lookup(each.value, "public_subnets_cidr", null)
  web_subnets_cidr     = lookup(each.value, "web_subnets_cidr", null)
  app_subnets_cidr     = lookup(each.value, "app_subnets_cidr", null)
  db_subnets_cidr      = lookup(each.value, "db_subnets_cidr", null)
  az                   = lookup(each.value, "az", null)

  env                  = var.env
  project_name         = var.project_name
}

module "rds" {
  source               = "./modules/rds"

  for_each             = var.rds
  instance_class       = lookup(each.value, "instance_class", null)
  allocated_storage    = lookup(each.value, "allocated_storage", null)
  dbname               = lookup(each.value, "db_name", null)
  engine               = lookup(each.value, "engine", null)
  engine_version       = lookup(each.value, "engine_version", null)
  family               = lookup(each.value, "family", null)

  env                  = var.env
  project_name         = var.project_name
  kms_key_id           = var.kms_key_id

  subnet_ids           = lookup(lookup(module.vpc, "main", null), "db_subnets_ids", null)
  vpc_id               = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  sg_cidr_blocks       = lookup(lookup(var.vpc, "main", null), "app_subnets_cidr", null)
}