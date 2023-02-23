project = "eShopOnContainers"

variable "app_name" {
  type    = string
  default = "eshop"
}

variable "dns" {
  type    = string
  default = "eshop"
}

variable "use_local_k8s" {
  type    = bool
  default = false
}

variable "use_mesh" {
  type    = bool
  default = false
}

variable "container_registry" {
  type    = string
  default = ""
}

variable "docker_username" {
  type    = string
  default = ""
}

variable "docker_password" {
  type    = string
  default = ""
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "namespace" {
  type    = string
  default = "eshop"
}

variable "ingress_mesh_annotations_file" {
  type    = string
  default = "ingress_values_linkerd.yaml"
}

variable "image_pull_policy" {
  type    = string
  default = "Always"
}

/*
app "seq" {
    labels = {
        "service" = "seq",
        "env"     = "local"
    }

    url {
        // Disable the Waypoint URL service from generating a name
        // for this app
        auto_hostname = false
    }

    build {
        use "docker-pull" {
            image = "datalust/seq"
            tag   = "latest"
            disable_entrypoint = true
        }
    }

    deploy {

    }
}*/
    

app "sqldata" {
    labels = {
        "service" = "sqldata",
        "env"     = "local"
    }

    url {
        // Disable the Waypoint URL service from generating a name
        // for this app
        auto_hostname = false
    }

    build {
        use "docker-pull" {
            image = "mcr.microsoft.com/mssql/server"
            tag   = "2019-latest"
            disable_entrypoint = true
        }
    }

    deploy {
        use "helm" {
            name  = app.name
            chart = "${path.app}/deploy/k8s/helm/sql-data"

            set {
                name  = "ingress.hosts"
                value = "{$dns}"
            }

            set {
                name  = "app.name"
                value = "{$app_name}"
            }
            
            set {
                name  = "inf.k8s.dns"
                value = "{$dns}"
            }
            
            set {
                name  = "inf.mesh.enabled"
                value = "{$use_mesh}"
            }

            // We use a values file so we can set the entrypoint environment
            // variables into a rich YAML structure. This is easier than --set
            values = [
                file(templatefile("${path.app}/deploy/k8s/helm/inf.yaml")),
                file(templatefile("${path.app}/deploy/k8s/helm/app.yaml")),
                file(templatefile("%{ if var.name != "" }${var.name}%{ else }${var.name}%{ endif }"))

            ]
        }
    }
} 

app "nosqldata" {
    labels = {
        "service" = "nosqldata",
        "env"     = "local"
    }

    url {
        // Disable the Waypoint URL service from generating a name
        // for this app
        auto_hostname = false
    }

    build {
        use "docker-pull" {
            image = "mongo"
            tag   = "latest"
            disable_entrypoint = true
        }
    }

    deploy {
        use "helm" {
            name  = app.name
            chart = "${path.app}/deploy/k8s/helm/nosql-data"

            set {
                name  = "deployment.name"
                value = "public-api"
            }

            // We use a values file so we can set the entrypoint environment
            // variables into a rich YAML structure. This is easier than --set
            values = [
                file(templatefile("${path.app}/deploy/k8s/helm/inf.yaml")),
                file(templatefile("${path.app}/deploy/k8s/helm/app.yaml")),
                file(templatefile("%{ if var.name != "" }${var.name}%{ else }${var.name}%{ endif }"))
            ]
        }
    }
}


app "basketdata" {
    labels = {
        "service" = "basketdata",
        "env"     = "local"
    }

    url {
        // Disable the Waypoint URL service from generating a name
        // for this app
        auto_hostname = false
    }

    build {
        use "docker-pull" {
            image = "redis"
            tag   = "alpine"
            disable_entrypoint = true
        }
    }

    deploy {
        use "helm" {
            name  = app.name
            chart = "${path.app}/deploy/k8s/helm/basket-data"

            set {
                name  = "deployment.name"
                value = "public-api"
            }

            // We use a values file so we can set the entrypoint environment
            // variables into a rich YAML structure. This is easier than --set
            values = [
                file(templatefile("${path.app}/deploy/k8s/helm/inf.yaml")),
                file(templatefile("${path.app}/deploy/k8s/helm/app.yaml")),
                file(templatefile("%{ if var.name != "" }${var.name}%{ else }${var.name}%{ endif }"))
            ]
        }
    }
}
    

app "rabbitmq" {
    labels = {
        "service" = "rabbitmq",
        "env"     = "local"
    }

    url {
        // Disable the Waypoint URL service from generating a name
        // for this app
        auto_hostname = false
    }

    build {
        use "docker-pull" {
            image = "rabbitmq"
            tag   = "3-management-alpine"
            disable_entrypoint = true
        }
    }

    deploy {
        use "helm" {
            name  = app.name
            chart = "${path.app}/deploy/k8s/helm/rabbitmq"

            set {
                name  = "deployment.name"
                value = "public-api"
            }

            // We use a values file so we can set the entrypoint environment
            // variables into a rich YAML structure. This is easier than --set
            values = [
                file(templatefile("${path.app}/deploy/k8s/helm/inf.yaml")),
                file(templatefile("${path.app}/deploy/k8s/helm/app.yaml")),
                file(templatefile("%{ if var.name != "" }${var.name}%{ else }${var.name}%{ endif }"))
            ]
        }
    }
}