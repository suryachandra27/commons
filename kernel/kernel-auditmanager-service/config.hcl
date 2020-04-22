log_level = "trace"

vault{
  address = "<Vault-Address>"
  token = "<Vault-Token>"
  renew_token = false

  retry {
    enabled = true
    attempts = 5
    backoff = "250ms"
  }
}

template {
  contents = <<EOH
    {{- with secret "<PathForCert>" "common_name=<UrlOfApp>" ttl=150h" -}}
    {{- .Data.issuing_ca -}}
    {{ end }}
  EOH
  destination   = "./cert/issuing_ca_certificate.crt"
  command = "keytool -importcert -alias issuing_ca_certificate -file ./cert/issuing_ca_certificate.crt -storepass ChangeIt -noprompt -storetype jks -keystore ./TrustStore.jks"
  perms = "0600"
  wait = "5s:10s"
}

template {
  contents = <<EOH
    {{- with secret "<PathForCert>" "common_name=<UrlOfApp>" "alt_names=/v1/auditmanager" "ttl=150h" -}}
    {{- .Data.certificate -}}
    {{ end }}
  EOH
  destination   = "./cert/certificate.crt"
  perms       = "0600"
}

template {
  contents = <<EOH
    {{- with secret "<PathForCert>" "common_name=<UrlOfApp>" "alt_names=/v1/auditmanager" "ttl=150h" -}}
    {{- .Data.private_key -}}
    {{ end }}
  EOH
  destination   = "./cert/private_key.key"
  command = "openssl pkcs12 -export -in ./cert/certificate.crt -inkey ./cert/private_key.key -name mosip -out ./cert/keystore-PKCS-12.p12 -passout pass:ChangeIt"
  perms = "0600"
  wait = "5s:10s"
}

exec {
  command = "keytool -importkeystore -alias mosip -deststorepass ChangeIt -noprompt -destkeystore ./KeyStore.jks -srckeystore ./cert/keystore-PKCS-12.p12 -srcstorepass ChangeIt -srcstoretype PKCS12"
}
