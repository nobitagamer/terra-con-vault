resource "null_resource" "tempImage" {
    provisioner "local-exec" {
        command = "docker build -f ${var.basePath}/${var.path}/${var.dockerfile} -t ${var.repository}/${var.name}:${var.tag} ${var.basePath}/${var.path}"
    }
}

resource "docker_image" "localImage" {
    depends_on = ["null_resource.tempImage"]
    name = "${var.repository}/${var.name}:${var.tag}"
    keep_updated = "${var.pull}"
}

output "dockerImage" {
    value = "${docker_image.localImage.latest}"
}
