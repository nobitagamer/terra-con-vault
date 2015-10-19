module "dockerImageHelper" {
    source = "../image-builder"
    name = "consul"
    path = "./consul"
    tag = "latest"
    pull = false
    repository = "quay.io/sweebr"
}

resource "docker_container" "consul" {
    name = "consul"
    hostname = "consul"
    image = "${module.dockerImageHelper.dockerImage}"
    must_run = true
    command = [
        "agent",
        "-server",
        "-client=0.0.0.0",
        "-advertise=192.168.99.100",
        "-bootstrap-expect=1",
        "-config-dir=/consul/conf.d"
    ]
    env = [
        "SERVICE_NAME=consul"
    ]
    volumes = {
        host_path = "${path.cwd}/consul/assets/conf.d"
        container_path = "/consul/conf.d"
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
