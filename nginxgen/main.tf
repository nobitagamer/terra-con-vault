variable basePath {}
variable consul {}
variable repository {}
variable dockerHostIp {}
variable nginxTemplate {}

module "dockerImageHelper" {
    source = "../image-builder"
    name = "nginxgen"
    basePath = "${var.basePath}"
    path = "nginxgen"
    tag = "latest"
    pull = false
    repository = "${var.repository}"
}

resource "null_resource" "copyNginxConfig" {
  provisioner "local-exec" {
    command = "cp ${path.cwd}/${var.nginxTemplate} ${path.cwd}/${var.basePath}/nginxgen/assets/templates/nginx.conf.ctmpl"
  }
}

resource "docker_container" "nginxgen" {
    depends_on = ["null_resource.copyNginxConfig"]
    name = "nginxgen"
    hostname = "nginxgen"
    image = "${module.dockerImageHelper.dockerImage}"
    must_run = true
    ports = {
        internal = 80
        external = 80
    }
    env = [
        "CONSUL=${var.dockerHostIp}:8500",
        "SERVICE_NAME=nginxgen",
        "SERVICE_TAGS=nginx"
    ]
}

output "ip" {
  value = "${docker_container.nginxgen.ip_address}"
}
