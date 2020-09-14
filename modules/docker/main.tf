resource "null_resource" "docker_installation" {
  count = length(var.nodes)
  connection {
    host        = element(var.nodes.*.ip, count.index)
    user        = var.docker_service_user
    private_key = file(var.docker_service_user_priv_key)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum check-update",
      "sudo curl https://releases.rancher.com/install-docker/${var.docker_version}.sh | sh",
      "sudo usermod -aG docker ${var.docker_service_user}",
      "sudo systemctl enable docker --now"
    ]
  }
}