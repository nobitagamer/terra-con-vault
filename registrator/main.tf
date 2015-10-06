variable consul {}

resource "docker_image" "registrator" {
    keep_updated = true
    name = "gliderlabs/registrator:latest"
}

resource "docker_container" "registrator" {
    name = "registrator"
    hostname = "registrator.consul"
    image = "${docker_image.registrator.latest}"
    must_run = true
    links = [
        "${var.consul}:consul"
    ]
    volumes = {
        host_path = "/var/run/docker.sock"
        container_path = "/tmp/docker.sock"
    }
    command = [
        "consul://consul:8500"
    ]
}

output "docker_image_name" {
    value = "${docker_image.registrator.latest}"
}
