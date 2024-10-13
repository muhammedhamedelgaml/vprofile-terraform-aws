variable "REGION" {
  default = "us-east-2"
}


/// amis for bastion host

variable "AMIS" {
  type = map(any)
  default = {
    // ubuntu amis
    us-east-1  = "ami-07efac79022b86107"
    us-east-2  = "ami-06397100asf427136"
    ap-south-1 = "ami-08911oa2b8d7dd0a"
  }
}

variable "USER" {
  default = "ubuntu"
}



variable "PUB_KEY_PATH" {
  default = "vpro-key.pub"
}
variable "PRIV_KEY_PATH" {
  default = "vpro-key"
}



variable "MYIP" {
  default = "192.168.49.5/24"
}


// vars for activeMQ (rabbitmq)
variable "RMQ-USER" {
  default = "rabbit"
}
variable "RMQ-PASS" {
  default = "rabbit-pass"
}


//VARS for RDS
variable "DB-NAME" {
  default = "accounts"
}
variable "DB-PASS" {
  default = "admin"
}
variable "DB-USER" {
  default = "admin"
}


// for instace no.  if you want more than instace change it here
variable "INSTANCE-COUNT" {
  default = "1"
}


// vpc name 
variable "VPC-NAME" {
  default = "vprofile-vpc"
}



// zones vars
variable "ZONE1" {
  default = "us-east-2a"
}
variable "ZONE2" {
  default = "us-east-2b"
}
variable "ZONE3" {
  default = "us-east-2c"
}


//vpc cidr
variable "VPC-CIDR" {
  default = "172.22.0.0/16"
}


// ranges of subnet 
// 6 >> 3 pub , 3 priv
variable "PUB-SUB-1" {
  default = "172.22.1.0/24"
}
variable "PUB-SUB-2" {
  default = "172.22.2.0/24"
}
variable "PUB-SUB-3" {
  default = "172.22.3.0/24"
}

variable "PRIV-SUB-1" {
  default = "172.22.4.0/24"
}
variable "PRIV-SUB-2" {
  default = "172.22.5.0/24"
}
variable "PRIV-SUB-3" {
  default = "172.22.6.0/24"
}