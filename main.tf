provider "docker" {
    # left empty intentionally to assume DOCKER_HOST and DOCKER_CERT_PATH
}

# CONSUL
# Provide easy service discovery and health-checks
module "consul" {
    source = "./consul"
    # Docker Hub repository
    repository = "${var.repository}"
    # Force binding to the docker host ip
    dockerHostIp = "${var.dockerHostIp}"
    # Dynamic basePath
    basePath = "${var.basePath}"
}

# REGISTRATOR
# Register services with Consul by listening to the docker socket
module "registrator" {
    source = "./registrator"
    # To make sure that consul is running we use it's name as a variable in other modules
    consul = "${module.consul.name}"
    # Force binding to the docker host ip
    dockerHostIp = "${var.dockerHostIp}"
}

# NGINXGEN
# Dynamically generate configuration based on the running services and reload NGiNX.
module "nginxgen" {
    source = "./nginxgen"
    # To make sure that consul is running we use it's name as a variable in other modules
    consul = "${module.consul.name}"
    # Docker Hub repository
    repository = "${var.repository}"
    # Dynamic basePath
    basePath = "${var.basePath}"
}

# VAULT
# Manage your secrets
module "vault" {
    source = "./vault"
    # To make sure that consul is running we use it's name as a variable in other modules
    consul = "${module.consul.name}"
    # Docker Hub repository
    repository = "${var.repository}"
    # Dynamic basePath
    basePath = "${var.basePath}"
}
