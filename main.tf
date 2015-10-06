provider "docker" {
    # left empty intentionally to assume DOCKER_HOST and DOCKER_CERT_PATH
    # host = "tcp://192.168.99.100:2376"
}

module "consul" {
    source = "./consul"
}

module "registrator" {
    source = "./registrator"
    consul = "${module.consul.name}"
}

module "nginxgen" {
    source = "./nginxgen"
    consul = "${module.consul.name}"
}

module "vault" {
    source = "./vault"
    consul = "${module.consul.name}"
}
