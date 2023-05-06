terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token = "${var.yc_token}"
  cloud_id  = "b1ggel59310trksk1fu4"
  folder_id = "b1g9oing6niujio3j61t"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "deb-1" {
  name = "debian11"
  platform_id = "standard-v3"
  resources {
    core_fraction = 20
    cores  = 2
    memory = 1
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fphfpeqijnlu1phu4"
      size = 3
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-3.id
    nat       = true
  }
  
  metadata = {
    user-data = "#cloud-config\nruncmd:\n  - 'wget -O - https://monitoring.api.cloud.yandex.net/monitoring/v2/unifiedAgent/config/install.sh | bash'\nusers:\n  - name: night\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("./yc-terraform.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }

}
resource "yandex_vpc_network" "network-2" {
  name = "network2"
}

resource "yandex_vpc_subnet" "subnet-3" {
  name           = "subnet3"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-2.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}

resource "yandex_monitoring_dashboard" "mydashboard" {
  depends_on = [
    yandex_compute_instance.deb-1
  ]
  name  = "debdashboard"
  title = "debdashboard"

  labels = {
    a = "b"
  }

  widgets {
    chart {
      chart_id       = "1"
      description    = "Debian CPU utilization"
      display_legend = false
      freeze         = "FREEZE_DURATION_UNSPECIFIED"
      title          = "Debian CPU utilization"

      name_hiding_settings {
        names    = []
        positive = false
      }

      queries {
        downsampling {
          gap_filling      = "GAP_FILLING_UNSPECIFIED"
          grid_aggregation = "GRID_AGGREGATION_UNSPECIFIED"
        }

        target {
          hidden    = false
          query     = "\"cpu_utilization\"{folderId=\"b1g9oing6niujio3j61t\", service=\"compute\", resource_id=\"debian11\"}"
          text_mode = false
        }
      }

      visualization_settings {
        aggregation = "SERIES_AGGREGATION_AVG"
        color_scheme_settings {
          automatic {}
        }
        interpolate   = "INTERPOLATE_LINEAR"
        normalize     = false
        show_labels   = false
        type          = "VISUALIZATION_TYPE_UNSPECIFIED"

        yaxis_settings {
          left {
            precision   = 0
            title       = ""
            type        = "YAXIS_TYPE_LINEAR"
            unit_format = "UNIT_NONE"
          }

          right {
            precision   = 0
            title       = ""
            type        = "YAXIS_TYPE_LINEAR"
            unit_format = "UNIT_NONE"
          }
        }
      }
      series_overrides {
        target_index = 0
        settings {
          grow_down        = false
          yaxis_position   = "YAXIS_POSITION_LEFT"
        }
      }
    }
    position {
      h = 8
      w = 12
      x = 0
      y = 0
    }
  }
}
output "internal_ip_address" {
  value = yandex_compute_instance.deb-1.network_interface.0.ip_address
}
output "external_ip_address" {
  value = yandex_compute_instance.deb-1.network_interface.0.nat_ip_address
}
