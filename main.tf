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
    docker_host_ip = "${var.docker_host_ip}"
    # Dynamic base_path
    base_path = "${var.base_path}"
    # Consul config path
    consul_config_path = "${var.consul_config_path}"
}

# REGISTRATOR
# Register services with Consul by listening to the docker socket
module "registrator" {
    source = "./registrator"
    # To make sure that consul is running we use it's name as a variable in other modules
    consul = "${module.consul.name}"
    # Force binding to the docker host ip
    docker_host_ip = "${var.docker_host_ip}"
}

# NGINXGEN
# Dynamically generate configuration based on the running services and reload NGiNX.
module "nginxgen" {
    source = "./nginxgen"
    # To make sure that consul is running we use it's name as a variable in other modules
    consul = "${module.consul.name}"
    # Docker Hub repository
    repository = "${var.repository}"
    # Dynamic base_path
    base_path = "${var.base_path}"
    # Force binding to the docker host ip
    docker_host_ip = "${var.docker_host_ip}"
    # Set template path
    nginx_template_path = "${var.nginx_template_path}"
}

# VAULT
# Manage your secrets
module "vault" {
    source = "./vault"
    # To make sure that consul is running we use it's name as a variable in other modules
    consul = "${module.consul.name}"
    # Docker Hub repository
    repository = "${var.repository}"
    # Dynamic base_path
    base_path = "${var.base_path}"
}

output "consul" {
  value = "${module.consul.ip}"
}

output "nginxgen" {
  value = "${module.nginxgen.ip}"
}
