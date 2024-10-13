// create DB-subent-group > collection of subnets 
resource "aws_db_subnet_group" "vprofile-RDS-subent-group" {
  name = "vprofile-RDS-subent-group"
  
  //    private_subnets = [var.PRIV-SUB-1, var.PRIV-SUB-2, var.PRIV-SUB-3] is list of 3 subent // created by vpc
  subnet_ids = [module.vpc.private_subnets[0],module.vpc.private_subnets[1],module.vpc.private_subnets[2]]
  
  tags = {
   name  =  "subnet grp for RDS" 
  }
}

// create elastic-cache subnet group 
resource "aws_elasticache_subnet_group" "vprofile-elasticache-subent-group" {
  name = "vprofile-elasticache-subent-group"
  subnet_ids =  [module.vpc.private_subnets[0],module.vpc.private_subnets[1],module.vpc.private_subnets[2]]
 
}


// now create RDS 

resource "aws_db_instance" "vprofile-RDS" {
  allocated_storage = 20 
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.6.34"
  instance_class = "db.t2.micro"
  parameter_group_name = "default.mysql5.6"
  multi_az = "false"
  publicly_accessible = "false"
  skip_final_snapshot = "true"

 // subnet group name of RDS                   
  db_subnet_group_name = aws_db_subnet_group.vprofile-RDS-subent-group.name
  // security group of backend 
  vpc_security_group_ids = [aws_security_group.vprofile-backend-sg.id]
  
  username = var.DB-USER
  password = var.DB-PASS
#   name     = var.DB-NAME
}





// create elasticache 

resource "aws_elasticache_cluster" "vprofile-elasticache" {
 cluster_id = "vprofile-elasticache"
  engine = "memcached"
  node_type = "cache.t2.micro"
  num_cache_nodes = 1
  parameter_group_name = "default.memcached1.5"
  port = 11211
  security_group_ids = [aws_security_group.vprofile-backend-sg.id]
  subnet_group_name = aws_elasticache_subnet_group.vprofile-elasticache-subent-group.name
}


// create activemq 

resource "aws_mq_broker" "vprofile-activeMQ" {
  broker_name = "vprofile-activeMQ"
  engine_type = "ActiveMQ"
  engine_version = "5.15.0"
  host_instance_type = "mq.t2.micro"
  security_groups = [aws_security_group.vprofile-backend-sg.id]
  subnet_ids = [module.vpc.private_subnets[0]]  // we don't have subnet-group-name like we did before so select subnets "you can select only one" 
  user {
    username = var.RMQ-USER
    password = var.RMQ-PASS
  }
}



