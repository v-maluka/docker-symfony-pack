#!make
#include .env
#export $(shell sed 's/=.*//' .env)

#httpd-reload:
#	docker-compose exec -T httpd apachectl -k graceful


console-mysql:
	@docker-compose exec mysql bash

logs-mysql:
	@docker-compose logs --tail=100 -f mysql

rebuild-mysql:
	docker-compose stop mysql
	docker rm $(docker ps -a -f name=mysql -q)
	docker rmi $(docker images -a -f reference='mysql' -q)
	docker-compose up -d mysql