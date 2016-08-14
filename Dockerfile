FROM php:5-fpm

RUN apt-get update && apt-get install -y curl wget git zlib1g-dev libicu-dev g++

RUN echo 'date.timezone = Europe/Copenhagen' > /usr/local/etc/php/conf.d/date.ini

RUN docker-php-ext-configure intl && docker-php-ext-install pdo pdo_mysql zip intl mysql mysqli

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer