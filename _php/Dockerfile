FROM composer:latest AS composer

FROM php:7.4-fpm-alpine

ARG env='production'

RUN mv "$PHP_INI_DIR/php.ini-$env" "$PHP_INI_DIR/php.ini"

RUN apk update && apk add --no-cache $PHPIZE_DEPS \
    git \
    vim \
    curl \
    unzip \
	gnupg \
	libzip-dev \
	autoconf \
	icu-dev

RUN docker-php-ext-configure zip
RUN docker-php-ext-install pdo pdo_mysql zip opcache intl

# Just installed, not activated by default
RUN apk add php7-pecl-xdebug --repository http://dl-3.alpinelinux.org/alpine/edge/community/
RUN pecl install xdebug

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN mkdir -p /var/www/html/

WORKDIR /var/www/html/

RUN docker-php-ext-install pcntl

EXPOSE 9000 9009

ENTRYPOINT ["php-fpm"]