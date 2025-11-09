resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  subnet_id     = var.public_subnet_id
  key_name      = var.key_pair_name

  associate_public_ip_address = true

  vpc_security_group_ids = [var.sg_id]

  tags = {
    Name   = "${var.namespace}-bastion"
    Projet = "projet-infra"
  }
}