// security group for vprofile beanstack load balancer 

resource "aws_security_group" "vprofile-bean-elb-sg" {
    name = "vprofile-bean-elb-sg"
    description = "security group for vprofile beanstack load balancer"
    vpc_id = module.vpc.vpc_id  
       
       //outbound rule
    egress  {
     // any port can go any way on internet
     from_port = 0
     to_port   = 0 
     protocol  = "-1"
     cidr_blocks = ["0.0.0.0/0"]
    }
      //inbound rule
    ingress {
    // allow connection on port 80 tcp from anywhere 
    from_port = 80
    to_port = 80
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

// security group for bastion host (ec2 instance)
resource "aws_security_group" "vprofile-bastion-sg" {
    name = "vprofile-bastion-sg"
    description = "security group for bastion host (ec2 instance)"
    vpc_id = module.vpc.vpc_id

     egress {
     // any port can go any way on internet
     from_port = 0
     to_port =  0 
     protocol = "-1"
     cidr_blocks = ["0.0.0.0/0"]
     }   

     ingress {
     // note that this is very important rule    
     // allow only ssh from myip 
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [var.MYIP]
     }
}

// security group for our beanstack enviroment 
resource "aws_security_group" "vprofile-sg" {
  name = "profile-sg"
  description = "security group for beanstack enviroment"
  vpc_id = module.vpc.vpc_id
   egress {
   // any port can go any way on internet (all the traffic can go anywhere)
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     // we need to allow ssh only from bastion host 
     // for security , only private connection from the bastion host security group is allowed  to the security group on port 22
      from_port = 22
      to_port = 22
      protocol = "tcp"
      security_groups = [aws_security_group.vprofile-bastion-sg.id]
   }
}


// security group for backend services (RDS,activemq ,elastic cache)
resource "aws_security_group" "vprofile-backend-sg" {
    name = "vprofile-backend-sg"
    description = "security group for backend services(RDS,activemq ,elastic cache)"
    vpc_id = module.vpc.vpc_id
    
    egress {
    // any port can go any way on internet (all the traffic can go anywhere)
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    } 

    ingress{
     // allow every thing from beanstack (vprofile)
     from_port = 0
     to_port = 0
     protocol = "-1"
     security_groups = [aws_security_group.vprofile-sg]
 
    }
}



// now we need to allow backend interact with itself(with each others)
// we want to allow all traffic from it's own security group, but it's not created yet 
// so we will use another resource to do that 
// aws_security_group_rule >> to update security group 

resource "aws_security_group_rule" "sg-vprofile-backend-allow-itself" {
   
   type = "ingress"
   from_port = 0
   to_port =  0           //  65535 in docs
   protocol = "tcp"
   security_group_id = aws_security_group.vprofile-backend-sg.id // security group we want to update
   source_security_group_id = aws_security_group.vprofile-backend-sg.id //security group we want to add 
}

 