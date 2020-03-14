#!make
include .env
export $(shell sed 's/=.*//' .env)

include _*/Makefile

.PHONY: rebuild up stop restart status console-app console-db console-srv clean help

docker-env: ssl config-nginx up hosts


reload:
	$(MAKE) reload-php
	$(MAKE) reload-nginx

restart:
	@echo "\n\033[1;m Restarting containers... \033[0m"
	@$(MAKE) stop
	@$(MAKE) up
	@$(MAKE) --no-print-directory status
up:
	@echo "\n\033[1;m Spinning up containers for Local dev environment... \033[0m"
	@docker-compose up -d

stop:
	@echo "\n\033[1;m  Halting containers... \033[0m"
	@docker-compose stop
	@$(MAKE) --no-print-directory status

dialog:
	@. ./dialog.sh

pull:
	@git pull
	@$(MAKE) restart

hosts:
	@echo "\n\033[1;m Adding record in to your local /etc/hosts file.\033[0m"
	@echo "\n\033[1;m Please use your local sudo password.\033[0m"
	@echo '127.0.0.1 localhost '${SERVER_NAME}' www.'${SERVER_NAME}''| sudo tee -a /etc/hosts
	@echo "\n\033[1;m Add next to your bookmarks:\033[0m"
	@echo 'https://${SERVER_NAME}:${SRV_SSL_PORT}'
#	@echo 'http://${ICE_SERVER_NAME}:${PMA_PORT} - PhpMyAdmin'

status:
	@echo "\n\033[1;m Containers statuses \033[0m"
	@docker-compose ps


console-rabbitmq:
	@docker-compose exec rabbitmq bash


help:
	@echo "clone\t\t\t- clone dev or staging repositories"
	@echo "up\t\t\t- start project"
	@echo "stop\t\t\t- stop project"
	@echo "restart\t\t\t- restart containers"
	@echo "status\t\t\t- show status of containers"
	@echo "nginx-config\t\t\t- generates httpd config file based on .env parameters"
	@echo "\033[1;31mclean\t\t\t- !!! Purge all Local application data!!!\033[0m"

	@echo "\n\033[1;mConsole section\033[0m"
	@echo "console-app\t\t- run bash console for dev application container"
	@echo "console-db\t\t- run bash console for mysql container"
	@echo "console-srv\t\t- run bash console for web server container"

	@echo "\n\033[1;mLogs section\033[0m"
	@echo "logs-srv\t\t- show web server logs"
	@echo "logs-db\t\t\t- show database logs"
	@echo "logs-app\t\t- show dev logs"
	@echo "\n\033[0;33mhelp\t\t\t- show this menu\033[0m"
