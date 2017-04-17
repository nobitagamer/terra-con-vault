backend "consul" {
  address = "192.168.147.130:8500"
  path = "vault"
}

listener "tcp" {
 address = "0.0.0.0:8200"
 tls_disable = 1
}

disable_mlock = true
