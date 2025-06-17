# outputs.tf
resource "local_file" "ansible_inventory" {
  filename = "../inventory.ini"
  content = templatefile("${path.module}/inventory.tpl", {
    controllers = aws_instance.controllers,
    workers     = aws_instance.worker_nodes,
    infra       = aws_instance.infra_nodes
  })
}

# Also output some useful info to the console
output "controller_ips" {
  value = aws_instance.controllers.*.private_ip
}

output "worker_ips" {
  value = aws_instance.worker_nodes.*.private_ip
}