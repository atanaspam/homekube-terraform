locals {
  kubeadm_token = format("%s.%s", random_password.first_token_substr.result, random_password.second_token_substr.result)
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
