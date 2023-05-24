FROM php:7.4-fpm

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    gnupg \
    gosu \
    ca-certificates \
    supervisor \
    sqlite3 \
    libcap2-bin \
    python2 \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    wget \
    libpq-dev

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync

RUN install-php-extensions gd \
    memcached \
    imap \
    pdo \
    pdo_mysql \
    zip \
    bcmath \
    soap \
    msgpack \
    pcntl \
    igbinary \
    redis

RUN apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN setcap "cap_net_bind_service=+ep" /usr/local/bin/php

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY project/ /var/www/html/

COPY php.ini /usr/local/etc/php/php.ini
COPY start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

ENTRYPOINT [ "start-container" ]