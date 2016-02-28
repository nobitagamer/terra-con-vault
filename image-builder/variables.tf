variable base_path {
  description = "base path to use when building images"
  default = "."
}

variable dockerfile {
  description = "Dockerfile name"
  default = "Dockerfile"
}

variable name {
  description = "Name of the docker image to build"
}

variable tag {
  description = "Tag to use"
  default = "latest"
}

variable pull {
  description = "Pull before build?"
  default = false
}

variable path {
  description = "Path to build at"
  default = "./"
}

variable repository {
  description = "Docker hub repository to use"
}

variable waitFor {
  description = "Other resource to wait on before running"
  default = 0
}
