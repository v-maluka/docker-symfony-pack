#!/bin/bash
set -e

if [ -f ./_nginx/ssl/server.cert ];
	then
  echo "SSL Certificates already exist. Skipping.." && exit 0;
else

COMMON_NAME1=${2:-*.$SERVER_NAME}
SUBJECT1="/C=CA/ST=None/L=NB/O=None/CN=$COMMON_NAME1"

mkdir -p ./_nginx/ssl
# echo "Generating ROOT key files"
# openssl genrsa -out rootCA.key 2048;

echo "Generating ROOT pem files"
openssl req -x509 -new -nodes -newkey rsa:2048 \
	-keyout _nginx/ssl/server_rootCA.key -sha256 -days 1024 \
	-out _nginx/ssl/server_rootCA.pem -subj "$SUBJECT1";

echo "Generating v3.ext file"
cat <<EOF > ./_nginx/ssl/v3.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = $SERVER_NAME
EOF

echo "Generating csr files"

openssl req -new -newkey rsa:2048 -sha256 -nodes \
	-newkey rsa:2048 -keyout _nginx/ssl/server.key \
	-subj "$SUBJECT1" \
	-out _nginx/ssl/server.csr;


echo "Generating certificate file"

openssl x509 -req -in _nginx/ssl/server.csr \
	-CA _nginx/ssl/server_rootCA.pem \
	-CAkey _nginx/ssl/server_rootCA.key \
	-CAcreateserial \
	-out _nginx/ssl/server.cert \
	-days 3650 -sha256 -extfile ./_nginx/ssl/v3.ext;

#Make browsers trust to newly generated certificates"
echo "Insert your local sudo password."
sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" _nginx/ssl/server_rootCA.pem; 2> /dev/null
fi