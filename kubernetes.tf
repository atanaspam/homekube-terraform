locals {
  kubeadm_token                 = format("%s.%s", random_password.first_token_substr.result, random_password.second_token_substr.result)
  kubernetes_ca                 = fileexists("${path.module}/ca/kubernetes-ca/kubernetes-ca.pem") ? file("${path.module}/ca/kubernetes-ca/kubernetes-ca.pem") : ""
  kubernetes_ca_key             = fileexists("${path.module}/ca/kubernetes-ca/kubernetes-ca-key.pem") ? file("${path.module}/ca/kubernetes-ca/kubernetes-ca-key.pem") : ""
  kubernetes_front_proxy_ca     = fileexists("${path.module}/ca/kubernetes-front-proxy-ca/kubernetes-front-proxy-ca.pem") ? file("${path.module}/ca/kubernetes-front-proxy-ca/kubernetes-front-proxy-ca.pem") : ""
  kubernetes_front_proxy_ca_key = fileexists("${path.module}/ca/kubernetes-front-proxy-ca/kubernetes-front-proxy-ca-key.pem") ? file("${path.module}/ca/kubernetes-front-proxy-ca/kubernetes-front-proxy-ca-key.pem") : ""
  etcd_ca                       = fileexists("${path.module}/ca/etcd-ca/etcd-ca.pem") ? file("${path.module}/ca/etcd-ca/etcd-ca.pem") : ""
  etcd_ca_key                   = fileexists("${path.module}/ca/etcd-ca/etcd-ca-key.pem") ? file("${path.module}/ca/etcd-ca/etcd-ca-key.pem") : ""
}

# The kubeadm token is of the form "[a-z0-9]{6}.[a-z0-9]{16}" Therefore we need to generate two substrings
# See https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-token/
resource "random_password" "first_token_substr" {
  length  = 6
  special = false
  upper   = false
}

resource "random_password" "second_token_substr" {
  length  = 16
  special = false
  upper   = false
}
