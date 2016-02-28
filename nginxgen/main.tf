variable base_path {}
variable consul {}
variable repository {}
variable docker_host_ip {}
variable nginx_template_path {}

module "dockerImageHelper" {
    source = "../image-builder"
    name = "nginxgen"
    base_path = "${var.base_path}"
    path = "nginxgen"
    tag = "latest"
    pull = false
    repository = "${var.repository}"
}

resource "null_resource" "copyNginxConfig" {
  provisioner "local-exec" {
    command = "cp ${path.cwd}/${var.nginx_template_path} ${path.cwd}/${var.base_path}/nginxgen/assets/templates/nginx.conf.ctmpl"
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
        "CONSUL=${var.docker_host_ip}:8500",
        "SERVICE_NAME=nginxgen",
        "SERVICE_TAGS=nginx"
    ]
}

output "ip" {
  value = "${docker_container.nginxgen.ip_address}"
}
