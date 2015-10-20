variable repository {
    description = "Docker Hub Repository prefix to use when pulling"
    default = "quay.io/sweebr"
}

variable dockerHostIp {
    description = "Docker Host Ip, used to force binding to it locally"
    default = "192.168.99.100"
}
