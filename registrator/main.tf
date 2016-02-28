variable consul {}
variable docker_host_ip {}

resource "docker_image" "registrator" {
    keep_updated = true
    name = "gliderlabs/registrator:latest"
}

resource "docker_container" "registrator" {
    name = "registrator"
    hostname = "registrator"
    image = "${docker_image.registrator.latest}"
    must_run = true
    volumes = {
        host_path = "/var/run/docker.sock"
        container_path = "/tmp/docker.sock"
        read_only = true
    }
    command = [
        "-ip=${var.docker_host_ip}",
        "consul://${var.docker_host_ip}:8500"
    ]
}

output "docker_image_name" {
    value = "${docker_image.registrator.latest}"
}
