variable repository {
    description = "Docker Hub Repository prefix to use when pulling or tagging a build"
}

variable dockerHostIp {
    description = "Docker Host Ip, used to force binding to it locally"
    default = "192.168.99.100"
}

variable basePath {
    description = "Enable loading these files as a tf module thus with a variable base path"
    default = "."
}

variable consulConfig {
  description = "Consul configuration file"
  default = "consul/assets/conf.d/consul.json.example"
}

variable nginxTemplate {
  description = "Change the default template path"
  default = "nginxgen/assets/templates/nginx.conf.ctmpl.example"
}
