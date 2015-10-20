provider "docker" {
    # left empty intentionally to assume DOCKER_HOST and DOCKER_CERT_PATH
    # host = "tcp://192.168.99.100:2376"
}

module "consul" {
    source = "./consul"
    # Docker Hub repository
    repository = "${var.repository}"
    # Force binding to the docker host ip
    dockerHostIp = "${var.dockerHostIp}"
}

module "registrator" {
    source = "./registrator"
    # To make sure that consul is running we use it's name as a variable in other modules
    consul = "${module.consul.name}"
    # Force binding to the docker host ip
    dockerHostIp = "${var.dockerHostIp}"
}

module "nginxgen" {
    source = "./nginxgen"
    # To make sure that consul is running we use it's name as a variable in other modules
    consul = "${module.consul.name}"
    # Docker Hub repository
    repository = "${var.repository}"
}

module "vault" {
    source = "./vault"
    # To make sure that consul is running we use it's name as a variable in other modules
    consul = "${module.consul.name}"
    # Docker Hub repository
    repository = "${var.repository}"
}
