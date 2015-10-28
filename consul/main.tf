variable basePath {}
variable dockerHostIp {}
variable repository {}
variable consulConfig {
  description = "Consul configuration file"
  default = "consul/assets/conf.d/consul.json.example"
}

module "dockerImageHelper" {
    source = "../image-builder"
    name = "consul"
    basePath = "${var.basePath}"
    path = "consul"
    tag = "latest"
    pull = false
    repository = "${var.repository}"
}

resource "null_resource" "copyConsulConfig" {
  provisioner "local-exec" {
    command = "cp ${path.cwd}/${var.consulConfig} ${path.cwd}/${var.basePath}/consul/assets/conf.d/consul.json"
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
        "-advertise=${var.dockerHostIp}",
        "-bootstrap-expect=1",
        "-config-dir=/consul/conf.d"
    ]
    env = [
        "SERVICE_NAME=consul"
    ]
    volumes = {
        host_path = "${path.cwd}/${var.basePath}/consul/assets/conf.d"
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

output "name" {
    value = "${docker_container.consul.name}"
}

output "ip" {
  value = "${docker_container.consul.ip_address}"
}
