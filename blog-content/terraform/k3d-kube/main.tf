
resource "kubernetes_config_map_v1" "configmap_nginx_cfgmap" {
  metadata {
    name = "nginxcfgmap"
  }
  data = {
    "file-from-cfgmap" = <<-EOT
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <title>From config map</title>
        </head>
        <body>
        
          <h1>Hello world from terraformn</h1>
        
        </body>
      </html>
      EOT
  }

}
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx"
    labels = {
      app = "nginx"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "nginx"
      }
    }

    replicas = 1

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx"



          port {
            container_port = 80
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/usr/share/nginx/html/index.html"
            sub_path   = "index.html"
          }
        }
        volume {
          name = "config-volume"


          config_map {
            name = "nginxcfgmap"
            items {
              key  = "file-from-cfgmap"
              path = "index.html"
            }

          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    labels = {

      name = "nginx"
    }
    name = "nginx"
  }

  spec {
    selector = {
      app = "nginx"

    }
    port {
      protocol    = "TCP"
      name        = "http"
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"

  }
}
resource "kubernetes_ingress_v1" "nginx" {
  metadata {
    name = "nginx"

    annotations = {
      "ingress.kubernetes.io/ssl-redirect" = "false"
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "nginx"

              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

# resource "kubernetes_ingress_v1" "example_ingress" {
#   metadata {
#     name = "example-ingress"
#     annotations = {
#       "ingress.kubernetes.io/ssl-redirect" : "false"
#       "kubernetes.io/ingress.class" : "nginx"
#     }
#   }

#   spec {
#     default_backend {
#       service {
#         name = "nginx"
#         port {
#           number = 8081
#         }
#       }
#     }

#     rule {
#       http {
#         path {
#           backend {
#             service {
#               name = "nginx"
#               port {
#                 number = 8081
#               }
#             }
#           }
#           pathType = "Prefix"
#           path = "/"
#         }

#       }
#     }

#   }
# }
