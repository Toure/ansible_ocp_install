# Data sources to read the ignition files created by Ansible
data "local_file" "bootstrap_ign" {
  filename = "../roles/upi_installer/files/generated/bootstrap.ign"
}

data "local_file" "master_ign" {
  filename = "../roles/upi_installer/files/generated/master.ign"
}

data "local_file" "worker_ign" {
  filename = "../roles/upi_installer/files/generated/worker.ign"
}

# --- Cluster Nodes ---
resource "aws_instance" "bootstrap" {
  count                  = 1 # Always one bootstrap node
  ami                    = var.ami_id
  instance_type          = var.instance_types["controller"] # Usually same size as controller
  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = [var.controller_sg_id]
  iam_instance_profile   = var.iam_instance_profile_name
  user_data_base64       = base64encode(data.local_file.bootstrap_ign.content)

  tags = {
    Name = "${var.cluster_name}-bootstrap"
  }
}

resource "aws_instance" "controllers" {
  count                  = 3 # Fixed at 3 controllers
  ami                    = var.ami_id
  instance_type          = var.instance_types["controller"]
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = [var.controller_sg_id]
  iam_instance_profile   = var.iam_instance_profile_name
  user_data_base64       = base64encode(data.local_file.master_ign.content)

  tags = {
    Name = "${var.cluster_name}-controller-${count.index}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_instance" "infra_nodes" {
  count                  = 3 # Fixed at 3 infra nodes
  ami                    = var.ami_id
  instance_type          = var.instance_types["infra"]
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = [var.worker_sg_id]
  iam_instance_profile   = var.iam_instance_profile_name
  user_data_base64       = base64encode(data.local_file.worker_ign.content)

  tags = {
    Name = "${var.cluster_name}-infra-${count.index}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_instance" "worker_nodes" {
  count                  = var.worker_node_count
  ami                    = var.ami_id
  instance_type          = var.instance_types["worker"]
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = [var.worker_sg_id]
  iam_instance_profile   = var.iam_instance_profile_name
  user_data_base64       = base64encode(data.local_file.worker_ign.content)

  tags = {
    Name = "${var.cluster_name}-worker-${count.index}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}
