{{ with secret "pki/issue/vetservices" "common_name=SERVER_NAME" }}{{ .Data.issuing_ca }}{{ end }}
