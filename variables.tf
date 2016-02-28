variable repository {
    description = "Docker Hub Repository prefix to use when pulling or tagging a build"
}

variable docker_host_ip {
    description = "Docker Host Ip, used to force binding to it locally"
    default = "192.168.99.100"
}

variable base_path {
    description = "Enable loading these files as a tf module thus with a variable base path"
    default = "."
}

variable consul_config_path {
  description = "Consul configuration file"
  default = "consul/assets/conf.d/consul.json.example"
}

variable nginx_template_path {
  description = "Change the default template path"
  default = "nginxgen/assets/templates/nginx.conf.example"
}
