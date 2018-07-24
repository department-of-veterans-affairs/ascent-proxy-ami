vault {
  renew_token   = false
  unwrap_token = false

  retry {
    attempts = 10
  }

  ssl {
    enabled = true
    verify  = false
  }
}

template {
  source = "/tmp/templates/ca.crt.tpl"
  destination = "/etc/nginx/certs/ca.crt"
  perms = 0644
}

template {
  source = "/tmp/templates/server.crt.tpl"
  destination = "/etc/nginx/certs/server.crt"
  perms = 0644
}

template {
  source = "/tmp/templates/server.key.tpl"
  destination = "/etc/nginx/certs/server.key"
  perms = 0644
}
