# terraform/terraform.tfvars

# --- Cluster Configuration ---
cluster_name = "ocp-cluster" # <-- Update this with your desired cluster name
aws_region   = "us-east-1" # <-- Update this with your desired AWS region

# The AMI ID for the nodes. This should be a Red Hat Enterprise Linux (RHEL)
# or Red Hat CoreOS (RHCOS) AMI suitable for your OpenShift version.
# Example for RHEL 8 in us-east-1.
ami_id       = "ami-0c55b159cbfafe1f0" # <-- Update this with your actual AMI ID

# --- Pre-existing AWS Infrastructure IDs ---
# These resources are NOT created by this Terraform configuration,
# but are required for the EC2 instances to be deployed correctly.

# Provide a list of at least two private subnet IDs for high availability.
subnet_ids = ["subnet-0123456789abcdef0", "subnet-fedcba9876543210f"] # <-- Update these with your actual subnet IDs

# The Security Group ID for the controller and bootstrap nodes.
controller_sg_id = "sg-0123456789abcdef0" # <-- Update this with your actual SG ID

# The Security Group ID for the infra and worker nodes.
worker_sg_id = "sg-fedcba9876543210f"  # <-- Update this with your actual SG ID

# The IAM Instance Profile NAME (not ARN) that provides the necessary
# permissions for OpenShift nodes to interact with AWS APIs.
iam_instance_profile_name = "openshift-node-profile" # <-- Update this with your actual IAM instance profile name


# --- Node Configuration ---

# The number of worker nodes you want in your cluster.
worker_node_count = 3 # <-- Update this based on your workload requirements

# The EC2 instance types for each role in the cluster.
# You can customize these based on your performance and cost requirements.
# defaults are provided in variables.tf.
#instance_types = {
#  controller = "m5.xlarge"
#  infra      = "m5.xlarge"
#  worker     = "m5.xlarge"
#}
instance_types = {
  controller = "m8g.2xlarge"
  infra      = "m8g.xlarge"
  worker     = "m8g.4xlarge"
}
