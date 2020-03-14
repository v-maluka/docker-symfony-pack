#!make
reload-php:
	docker-compose exec -T php kill -USR2 1

console-php:
	@docker-compose exec php sh

logs-php:
	@docker-compose logs --tail=100 -f php

