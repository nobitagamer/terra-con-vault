terra-con-vault
===============

What is this repository?
------------------------

POC using Terraform, Consul and Vault. This repo will allow you to spin up a Consul server with a UI.

If you plan to use Vault + Consul and Terraform to achieve a well formed infrastructure this is a solid starting point.

You're able to spin up the 'cluster' with either `docker-compose` or `terraform`.

Both solutions enable you to further extend the base and customize to your needs.

Getting Started
===============

Prerequisites
-------------

-	[Docker](https://docs.docker.com/installation/)
-	[Docker Compose](https://docs.docker.com/compose/install/) installed. (Optional) - If you use docker-compose instead of terraform
-	[Terraform](https://terraform.io/) is nice to have if you plan on using terraform instead of docker-compose

Docker Setup
------------

### Consul

-	Create the Consul configuration file that will be mounted to the container as part of the conf.d directory: `cp consul/assets/conf.d/consul.json.example /consul/assets/conf.d/consul.json`

### NGiNXGen

-	Create the NGiNX configuration file that will be mounted to the container as part of the templates directory: `cp nginxgen/assets/templates/nginx.conf.example nginxgen/assets/templates/nginx.conf`

*Make sure to change the service you're looking for to match the SERVICE_NAME you're to introduce.*

#### Published ports

-	53 (DNS)
-	8500 (HTTP)

DNS Forwarding
--------------

### Mac OS X

For proper forwarding of the DNS queries to consul and so resolving domains like `consul.node.consul` or `vault.service.consul` it is required that you configure your resolver to look for .consul queries at your `DOCKER_HOST` to achieve that it's the easiest to:

```shell
DOCKER_MACHINE_NAME="default"
DOCKER_MACHINE_IP=$(docker-machine ip $DOCKER_MACHINE_NAME)
networksetup -setdnsservers Wi-Fi $DOCKER_MACHINE_IP 8.8.8.8
networksetup -setsearchdomains Wi-Fi consul net
```

Notes
-----

Docker Image: [progrium/consul](https://hub.docker.com/r/progrium/consul/)

Let's run it already!
---------------------

Just `terraform apply`. Everything should *just work*.

Using this as a module in your project
======================================

I found that it's pretty neat to just use this as a terraform module in your own project. So this piece of infrastructure is encapsulated and reusable.

To achieve this given that terraform's module system will resolve everything relative to the root module. There's a variable which is to mitigate this called `basePath`.

The idea is that by default basePath is `.` meaning that whenever it's used it still just resolves to root by default. However when you have these files in a subfolder of the project you'd want to use that folder as `basePath`.

Thus all the paths set for image-builder would still work.

IMHO we should see the terraform docker provider improve and then image-builder shouldn't be necessary anymore.

Assuming you've set up a git submodule for terra-con-vault at the `terraform` path in your project root.

Then you could include the project as:

```
provider "docker" {}

module "backingInfrastructure" {
  source = "./terraform"
  basePath = "terraform"
}

module "apiImage" {
    source = "./terraform/image-builder"
    name = "api"
    dockerfile = "Dockerfile.api"
    path = "."
    tag = "latest"
    pull = false
    repository = "${var.repository}"
}

resource docker_container "api" {
  name = "api"
  hostname = "api"
  image = "${module.apiImage.dockerImage}"
  must_run = true
  links = [
    "redis:redis"
  ]
  ports = {
    internal = 8084
    external = 8084
  }
  env = [
    "SERVICE_NAME=api"
  ]
}

```

### Where

-	`backingInfrastructure` refers to terra-con-vault
-	`apiImage` is an image you want to build in your project and possibly use it later to start a container
-	`SERVICE_NAME` env variable will take care of naming your service in consul while registering it *magic*
-	`SERVICE_TAGS` can optionally be provided to further separate services

### You should use Packer! It's for building your Docker images!

Yep, but no. It just doesn't work out of the box on OS X and that's a no-go. sshfs is just bad for your health.

*Further reading for the IT masochist:* [Why you're not getting packer in this POC](https://github.com/mitchellh/packer/wiki/Using-packer-on-Mac-OS-X-with-boot2docker)

### Further down the road

-	Better bootstrap (consul.json)
-	Atlas integration
-	Local Development environment with automatic tests
-	Some cleaning and an initial release to the community
-	Auto-Unseal Vault
-	Populate Consul with keys
-	Bootstrap application configuration with `envconsul`
