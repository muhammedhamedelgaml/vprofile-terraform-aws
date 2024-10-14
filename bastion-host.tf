resource "aws_instance" "bastion-host" {
  ami                    = lookup(var.AMIS, var.REGION)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.vprokey.key_name
  subnet_id              = module.vpc.public_subnets[0] // inst will be in first pub. subnet 
  count                  = var.INSTANCE-COUNT
  vpc_security_group_ids = [aws_security_group.vprofile-bastion-sg.id]

  tags = {

    name    = "bastion-host"
    project = "vprofile"
  }

  // initialize DB using provisioner file and remote-exec

  // 1- upload file
  provisioner "file" {
    content     = templatefile("template/db-initialize.tmpl", { RDS-endpoint = aws_db_instance.vprofile-RDS.address, DB-USER = var.DB-USER, DB-PASS = var.DB-PASS })
    destination = "/tmp/db-initialize.sh"
  }

  // 2- execute file 
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/db-initialize.sh ",
      "sudo /tmp/db-initialize.sh "
    ]
  }

  // 3- connect terraform with bastion-host
  connection {
    user        = var.USER
    private_key = file(var.PRIV_KEY_PATH)
    host        = self.public_ip
  }




  // we need RDS created first 
  depends_on = [aws_db_instance.vprofile-RDS]


  //finally we need to go to security group of (backend > RDS ) and allow 3306 from bastion-host security group 
}