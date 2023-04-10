FROM php:8.2.4-fpm as php_base

WORKDIR /var/www/html

RUN apt-get update \
    && apt-get install -y \
    zsh \
    git \
    curl \
    unzip \
    wget \
    libzip-dev \
    libpng-dev \
    libmagickwand-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev \
    libyaml-dev

RUN pecl install \
    redis \
    xdebug \
    zstd \
    imagick \
    mongodb \
    zip \
    yaml

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

RUN docker-php-ext-install \
    gd \
    bcmath \
    exif \
    sockets

RUN docker-php-ext-enable \
    redis \
    xdebug \
    mongodb \
    imagick \
    zstd \
    bcmath \
    exif \
    zip \
    yaml \
    sockets

RUN chown -R www-data:www-data /var/www/

EXPOSE 9000

# For PHP container with application
FROM php_base as php_app
ARG NODE_VERSION=18

RUN curl -sS https://getcomposer.org/installer  \
    | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm

# Set your group and user for application
USER 0:0

# For PHP container with application jobs
FROM php_base as php_supervisor

RUN apt-get update && apt-get install -y supervisor

# Set your group and user for supervisor
USER 0:0
