{{ with secret "pki/issue/vetservices-dot-gov" "common_name=SERVER_NAME" }}{{ .Data.issuing_ca }}{{ end }}
