output "cluster_name" {
  value = aws_eks_cluster.user-profile-cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.user-profile-cluster.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.user-profile-cluster.certificate_authority[0].data
}

output "bastion_host" {
  value = aws_instance.bastion.public_dns
}
