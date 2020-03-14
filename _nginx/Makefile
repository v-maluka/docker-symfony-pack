#!make
console-nginx:
	@docker-compose exec nginx bash

logs-nginx:
	@docker-compose logs --tail=100 -f nginx

reload-nginx:
	docker-compose exec -T nginx /etc/init.d/nginx reload

config-nginx:
	@. ./_nginx/config.sh

ssl:
	@echo "\n\033[1;m Generating self-signed SSL certificates... \033[0m"
	@bash ./_nginx/ssl.sh