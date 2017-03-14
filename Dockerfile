FROM php:5-fpm

RUN apt-get update && apt-get install -y curl wget git zlib1g-dev libicu-dev g++ libmcrypt-dev nano

RUN echo 'date.timezone = Europe/Copenhagen' > /usr/local/etc/php/conf.d/date.ini
RUN echo 'memory_limit = "1G"' > /usr/local/etc/php/conf.d/memory.ini

RUN docker-php-ext-configure intl && docker-php-ext-install pdo pdo_mysql zip intl mysql mysqli pcntl mcrypt

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/2.2.7.tar.gz \
    && tar -xzf /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mkdir /usr/src/php \
    && mkdir /usr/src/php/ext \
    && mv phpredis-2.2.7 /usr/src/php/ext/redis \
    && docker-php-ext-install redis

WORKDIR /var/www/application
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer