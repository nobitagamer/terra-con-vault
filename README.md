terra-con-vault
===============

What is this repository?
------------------------

POC using Terraform, Consul and Vault. This repo will allow you to spin up a Consul server with a UI.

Getting Started
===============

Prerequisites
-------------

-	[Docker](https://docs.docker.com/installation/)
-	[Docker Compose](https://docs.docker.com/compose/install/) installed.
-	[Terraform](https://terraform.io/) is nice to have

Docker Setup
------------

### Consul

-	Create the Consul configuration file that will be mounted to the container as part of the conf.d directory: `cp consul/assets/conf.d/consul.json.example /consul/assets/conf.d/consul.json`

#### Published ports

-	53 (DNS)
-	8500 (HTTP)

DNS Forwarding
--------------

### Mac OS X

For proper forwarding of the DNS queries to consul and so resolving domains like `consul.node.consul` or `vault.service.consul` it is required that you configure your resolver to look for .consul queries at your DOCKER_HOST to achieve that it's the easiest to:

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
