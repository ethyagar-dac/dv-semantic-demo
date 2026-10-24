  mkdir -p ~/.snowflake
  openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out ~/.snowflake/dbt_svc_key.p8 -nocrypt
  chmod 600 ~/.snowflake/dbt_svc_key.p8
  # print the public key as one line, to paste into Snowflake:
  openssl rsa -in ~/.snowflake/dbt_svc_key.p8 -pubout | grep -v "PUBLIC KEY" | tr -d '\n'; echo
