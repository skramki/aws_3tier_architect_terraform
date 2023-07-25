resource "aws_instance" "web" {
  ami           = "ami-0acb5e61d5d7b19c8"
  instance_type = "t2.micro"
  key_name = "ec2-mgt-key"
  subnet_id = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  associate_public_ip_address = true
  count = 2

  tags = {
    Name = "WebServer"
  }
    provisioner "remote-exec" {
    inline = [
      "sudo yum install -y httpd",
      "sudo service httpd start"
    ]

    connection {
      type = "ssh"
      host = self.public_ip
      user = "ec2-user"
      private_key = "${file("./ec2-mgt-key.pem")}"
    }  
  }
}
