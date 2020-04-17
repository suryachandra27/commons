log_level = "trace"

vault{
  address = "http://192.168.10.5:8200"
  token = ""
  renew_token = false

  retry {
    enabled = true
    attempts = 5
    backoff = "250ms"
  }
}

template {
  contents = <<EOH
    {{- with secret "" "common_name=" "alt_names=" "ttl=150h" -}}
    {{- .Data.issuing_ca -}}
    {{ end }}
  EOH
  destination   = "./cert/issuing_ca_certificate.crt"
  command = "keytool -importcert -alias issuing_ca_certificate -file ./cert/issuing_ca_certificate.crt -storepass ChangeIt -noprompt -storetype jks -keystore ./SSL/TrustStore.jks"
  perms = "0600"
  wait = "5s:10s"
}

template {
  contents = <<EOH
    {{- with secret "" "common_name=" "alt_names=" "ttl=150h" -}}
    {{- .Data.certificate -}}
    {{ end }}
  EOH
  destination   = "./cert/certificate.crt"
  perms       = "0600"
}

template {
  contents = <<EOH
    {{- with secret "" "common_name=" "alt_names=" "ttl=150h" -}}
    {{- .Data.private_key -}}
    {{ end }}
  EOH
  destination   = "./cert/private_key.key"
  command = "openssl pkcs12 -export -in ./cert/certificate.crt -inkey ./cert/private_key.key -name keystore -out ./cert/keystore-PKCS-12.p12 -passout pass:ChangeIt"
  perms = "0600"
  wait = "5s:10s"
}

exec {
  command = "keytool -importkeystore -alias <to be set> -deststorepass ChangeIt -destkeystore ./SSL/KeyStore.jks -srckeystore ./cert/keystore-PKCS-12.p12 -srcstorepass ChangeIt -srcstoretype PKCS12"
}
