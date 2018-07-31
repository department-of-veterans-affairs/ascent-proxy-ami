{{ with secret "pki/issue/vetservices-dot-gov" "common_name=SERVER_NAME" }}{{ .Data.private_key }}{{ end }}
