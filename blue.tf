resource "aws_instance" "blue" {
  count = var.enable_blue_env ? var.blue_instance_count : 0

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)]
  vpc_security_group_ids = [module.app_security_group.this_security_group_id]
  user_data = templatefile("${path.module}/init-script.sh", {
    file_content = "version 1.0 - #${count.index}"
  })

  tags = {
    Name = "blue-${count.index}"
  }
}