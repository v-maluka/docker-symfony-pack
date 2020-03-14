#!/bin/bash
echo "\n\033[1;m Generating nginx config file... \033[0m"
cat <<EOF > _nginx/conf.d/$SERVER_NAME.conf
server {
	listen 8080 default_server;
	listen 443 ssl;
	root /var/www/html/web;
	index index.html index.php index.htm;
	server_name $SERVER_NAME www.$SERVER_NAME;

	ssl_certificate /etc/nginx/ssl/server.cert;
	ssl_certificate_key /etc/nginx/ssl/server.key;

	if (\$scheme = http) {
	  return 301 https://\$server_name\$request_uri;
	}

	location ~ \.(js|css|png|jpg|jpeg|svg|eot|ttf|woff|woff2|json|htc|ico) {
		add_header Access-Control-Allow-Origin *;
		access_log off;
		expires 30d;
	}

	location / {
        try_files \$uri \$uri/ /index.php?\$query_string;

		location ~ \.php$ {
			fastcgi_split_path_info ^(.+\.php)(/.+)$;
			fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
			fastcgi_param DOCUMENT_ROOT \$realpath_root;
			fastcgi_param REMOTE_ADDR 127.0.0.1;
			fastcgi_param APP_ENVIRONMENT '$APP_ENV';
			fastcgi_index index.php;
			include fastcgi_params;
			fastcgi_pass php:9000;
		}
	}
}
EOF
