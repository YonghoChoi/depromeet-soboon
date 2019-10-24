resource "aws_spot_instance_request" "elasticstack" {
  ami                  = var.ami_id
  key_name             = var.key_pair
  instance_type        = var.instance_type
  vpc_security_group_ids = var.es_sg_ids

  spot_price = var.spot_price
  spot_type = var.spot_type
  wait_for_fulfillment = var.wait_for_fulfillment

  root_block_device {
    volume_size = var.volume_size
  }

  subnet_id                   = var.public_subnet_ids[0]
  associate_public_ip_address = true
  user_data = local.elasticstack_userdata

  tags = merge(
    map("key", "Name", "value", local.name),
    var.base_tags
  )

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = var.ec2_password
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "${path.module}/../../../docker/compose/elasticstack"
    destination = "~/elasticstack"
  }

  provisioner "remote-exec" {
    inline = [
      "cd ~/elasticstack",
      "dos2unix *",
      "sudo sysctl -w vm.max_map_count=262144",
      "docker-compose up -d",
      "sleep 10",
    ]
  }
}

locals {
  elasticstack_userdata = <<USERDATA
#!/bin/bash
# docker install
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common awscli unzip dos2unix python3-pip
pip3 install --upgrade --user awscli

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce
usermod -aG docker ubuntu
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# set vm map max count
echo "vm.max_map_count=262144" > /etc/sysctl.conf

# set password
echo "ubuntu:${var.ec2_password}" | chpasswd
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
service sshd restart
USERDATA
}