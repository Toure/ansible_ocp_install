variable "cluster_name" {
  description = "The name of the OpenShift cluster."
  type        = string
}

variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
}

variable "subnet_ids" {
  description = "A list of private subnet IDs where cluster nodes will be deployed."
  type        = list(string)
}

variable "controller_sg_id" {
  description = "The ID of the security group for controller nodes."
  type        = string
}

variable "worker_sg_id" {
  description = "The ID of the security group for worker and infra nodes."
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for the cluster nodes (e.g., RHEL or RHCOS)."
  type        = string
}

variable "worker_node_count" {
  description = "The number of worker nodes to provision."
  type        = number
  default     = 3
}

variable "instance_types" {
  description = "A map of instance types for each node role."
  type = map(string)
  default = {
    controller = "m5.xlarge"
    infra      = "m5.xlarge"
    worker     = "m5.xlarge"
  }
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile for the nodes."
  type        = string
}