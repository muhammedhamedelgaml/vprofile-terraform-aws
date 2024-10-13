
resource "aws_elastic_beanstalk_environment" "vprofile-bean-prod" {
    name = "vprofile-bean-prod"
    application = aws_elastic_beanstalk_application.vprofile-prod.name
    solution_stack_name = "64bit Amazon Linux 2023 v5.3.3 running Tomcat 9 Corretto 11"
    cname_prefix = "vprofile-bean-prod-domain"  // url //Prefix to use for the fully qualified DNS name of the Environment.




//  vpc settings
  setting {
    namespace = "aws:ec2:vpc"
    name = "VPCId"
    value = module.vpc.vpc_id 
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "AssociatePublicIpAddress"
    value = "false"  
  }
 setting {
    namespace = "aws:ec2:vpc"
    // we want to put all the instance in the private subnets 
    name = "Subnets"
    // we will use join beacuse subnets in a list and we want to pass it as string 
    value = join("," , [module.vpc.private_subnets[0] , module.vpc.private_subnets[1],module.vpc.private_subnets[2]]) 
  
  }
 setting {
    namespace = "aws:ec2:vpc"
    // load balancer will be in public subnets
    name = "ELBSubnets"
    value = join("," , [module.vpc.public_subnets[0] , module.vpc.public_subnets[1],module.vpc.public_subnets[2]]) 
  }





//  launch configuration settings
 setting {
  namespace = "aws:autoscaling:launchconfiguration"
   name = "IamInstanceProfile"
   value = "aws-elasticbeanstalk-ec2-role"  
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = "t2.micro"  
  }
    setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "EC2KeyName"
    // key name we created on aws 
    value = aws_key_pair.vprokey.key_name   
  }
    setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "SecurityGroups"
    value = aws_security_group.vprofile-sg.id 
  }
   





//  autoScaling settings
setting {
  namespace = "aws:autoscaling:asg"
  name =  "Availability Zones"
  // at any 3 Availability Zones
  value = "Any 3"
}
setting {
  namespace = "aws:autoscaling:asg"
  name =  "MinSize"
  value = var.INSTANCE-COUNT
}
setting {
  namespace = "aws:autoscaling:asg"
  name =  "MaxSize"
  value = "1"
}




// make enviroment name prod 
setting {
  namespace = "aws:elasticbeanstalk:application:environment"
  name =  "enviroment"
  value = "prod"
}
// log setting
// can't find it in docs
setting {
  namespace = "aws:elasticbeanstalk:application:environment"
  name =  "LOGGING_APPENDER"
  value = "GRAYLOG"
}


// health checking
setting {
  namespace = "aws:elasticbeanstalk:healthreporting:system"
  name =  "SystemType"
  value = "basic"   // or "enhanced"  // AWS Elastic Beanstalk uses information from multiple sources to determine if your environment is available and processing requests from the Internet. An environment's health is represented by one of four colors
  
} 




// update policy (rolling update)
setting {
namespace = "aws:elasticbeanstalk:command"
name = "DeploymentPolicy"
value = "Rolling"  
}
setting {
  namespace = "aws:autoscaling:updatepolicy:rollingupdate"
  name =  "RollingUpdateEnabled"
  value = "true"
}
setting {
  namespace = "aws:autoscaling:updatepolicy:rollingupdate"
  name =  "RollingUpdateType"
  value = "Health" // default"Time",Immutable/// Time-based rolling updates apply a PauseTime between batches. Health-based rolling updates wait for new instances to pass health checks before moving on to the next batch. Immutable updates launch a full set of instances in a new Auto Scaling group
}
setting {
  namespace = "aws:autoscaling:updatepolicy:rollingupdate"
  name =  "MaxBatchSize"
  value = "1"   // one by one do rolling update 
}




// load balancer settings
setting {
  namespace = "aws:elb:loadbalancer" 
  name = "CrossZone"  // Configure the load balancer to route traffic evenly across all instances in all Availability Zones rather than only within each zone
  value = "true"
}
setting {
  namespace = "aws:elbv2:loadbalancer" 
  name = "SecurityGroups"  
  value = aws_security_group.vprofile-bean-elb-sg.id
}




// enable stickiness 
setting {
  namespace = "aws:elasticbeanstalk:environment:process:default"
  name = "StickinessEnabled"
  value = "true"
}


// aws:elasticbeanstalk:command
setting {
namespace = "aws:elasticbeanstalk:command"
name = "BatchSizeType"
value = "Fixed" // or"Percentage" // The type of number that's specified in BatchSize. 
}
setting {
namespace = "aws:elasticbeanstalk:command"
name = "BatchSize"
value = "1"  // the fixed number of Amazon EC2 instances in the Auto Scaling group to simultaneously perform deployments 
}







// terraform is smart but to avoid any error add dependency > first security group of (app ,lb) then the beanstalk enviroment and 
depends_on = [ aws_security_group.vprofile-sg ,aws_security_group.vprofile-bean-elb-sg]
}

