resource "aws_spot_instance_request" "this" {
  ami                  = var.soboon_ami_id
  key_name             = var.key_pair
  instance_type        = var.soboon_web_instance_type
  iam_instance_profile = var.iam_instance_profile_name
  vpc_security_group_ids = var.security_group_ids

  spot_price = var.spot_price
  spot_type = var.spot_type
  wait_for_fulfillment = var.wait_for_fulfillment

  root_block_device {
    volume_size = var.volume_size
  }

  subnet_id                   = var.subnet_ids[0]
  associate_public_ip_address = true
  user_data = local.k8s_userdata

  tags = {
    Name = var.name
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = var.password
    host        = self.public_ip
  }

  provisioner "file" {
    # Develop과 동일한 구성으로 Kubernetes 클러스터를 설정하기 때문에 develop 디렉토리 참조
    source      = "${path.module}/../../../kubernetes"
    destination = "~/k8s"
  }
}

resource "null_resource" "run_coomand" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      password    = var.password
      host        = aws_spot_instance_request.this.public_ip
    }

    inline = [
      // filebeat로 수집한 데이터 전달을 위해 elasticsearch endpoint를 configmap에 등록
      "kubectl create configmap elasticsearch-config --from-literal endpoint=${aws_spot_instance_request.elasticstack.private_ip}:9200",

      // kubernetes 리소스 생성
      "cd ~/k8s",
      "dos2unix *",
      "chmod +x *.sh",
      "./create.sh ${var.environment}",
      "sleep 10",
    ]
  }

  depends_on = ["aws_spot_instance_request.this"]
}

locals {
  k8s_userdata = <<USERDATA
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

# kubernetes install
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sh -c 'echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list'
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
kubeadm init

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
echo "export KUBECONFIG=$HOME/.kube/config" >> ~/.bashrc
source ~/.bashrc

export USER_HOME=/home/ubuntu
mkdir -p $USER_HOME/.kube
cp -i /etc/kubernetes/admin.conf $USER_HOME/.kube/config
chown -R ubuntu:ubuntu $USER_HOME/.kube
echo "export KUBECONFIG=$USER_HOME/.kube/config" >> $USER_HOME/.bashrc
source ~/.bashrc

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
kubectl taint nodes --all node-role.kubernetes.io/master-
echo 'source <(kubectl completion bash)' >> /etc/profile

# set password
echo "ubuntu:${var.password}" | chpasswd
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
service sshd restart
USERDATA
}
