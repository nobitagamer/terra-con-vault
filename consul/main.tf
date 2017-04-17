variable base_path {}
variable docker_host_ip {}
variable repository {}
variable consul_config_path {}

module "dockerImageHelper" {
    source = "../image-builder"
    name = "consul"
    base_path = "${var.base_path}"
    path = "consul"
    tag = "latest"
    pull = false
    repository = "${var.repository}"
}

resource "null_resource" "copyConsulConfig" {
  provisioner "local-exec" {
    command = "cp ${path.cwd}/${var.consul_config_path} ${path.cwd}/${var.base_path}/consul/assets/conf.d/consul.json"
  }
}

resource "docker_container" "consul" {
    depends_on = ["null_resource.copyConsulConfig"]
    name = "consul"
    hostname = "consul"
    image = "${module.dockerImageHelper.dockerImage}"
    must_run = true
    command = [
        "agent",
        "-server",
        "-client=0.0.0.0",
        "-advertise=${var.docker_host_ip}",
        "-bootstrap-expect=1",
        "-config-dir=/consul/conf.d"
    ]
    env = [
        "SERVICE_NAME=consul"
    ]
    volumes = {
        host_path = "${path.cwd}/${var.base_path}/consul/assets/conf.d"
        container_path = "/consul/conf.d"
    }
    ports = {
        internal = 8300
        external = 8300
    }
    ports = {
        internal = 8400
        external = 8400
    }
    ports = {
        internal = 8500
        external = 8500
    }
    ports = {
        internal = 53
        external = 53
        protocol = "udp"
    }
}

provider "consul" {
  address = "${var.docker_host_ip}:8500"
  datacenter = "dc1"
  scheme = "http"
}

resource "null_resource" "log" {
  provisioner "local-exec" {
    command = "echo Consul running at: ${docker_container.consul.ip_address}; sleep 5;"
  }
}

resource "consul_keys" "docker" {
  depends_on = ["null_resource.log"]
  datacenter = "dc1"
  key {
    name = "docker_host_ip"
    path = "dev/config/docker/host"
    default = "${var.docker_host_ip}"
    value = "${var.docker_host_ip}"
  }
}

output "name" {
    value = "${docker_container.consul.name}"
}

output "ip" {
  value = "${docker_container.consul.ip_address}"
}
