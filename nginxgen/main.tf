variable consul {}
variable repository {}

module "dockerImageHelper" {
    source = "../image-builder"
    name = "nginxgen"
    path = "./nginxgen"
    tag = "latest"
    pull = false
    repository = "${var.repository}"
}

resource "docker_container" "nginxgen" {
    name = "nginxgen"
    hostname = "localhost.dev"
    image = "${module.dockerImageHelper.dockerImage}"
    must_run = true
    links = [
        "${var.consul}:consul"
    ]
    ports = {
        internal = 80
        external = 80
    }
    env = [
        "CONSUL=consul:8500",
        "SERVICE_NAME=nginxgen",
        "SERVICE_TAGS=nginx"
    ]
}
