FROM php:5-fpm

RUN apt-get update && apt-get install -y curl wget git zlib1g-dev libicu-dev g++

RUN echo 'date.timezone = Europe/Copenhagen' > /usr/local/etc/php/conf.d/date.ini

RUN docker-php-ext-configure intl && docker-php-ext-install pdo pdo_mysql zip intl mysql mysqli 

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/2.2.7.tar.gz \
    && tar -xzf /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mkdir /usr/src/php \
    && mkdir /usr/src/php/ext \
    && mv phpredis-2.2.7 /usr/src/php/ext/redis \
    && docker-php-ext-install redis

RUN touch /usr/local/etc/php/conf.d/xdebug.ini; \
    echo xdebug.remote_enable=1 >> /usr/local/etc/php/conf.d/xdebug.ini; \
    echo xdebug.remote_connect_back=1 >> /usr/local/etc/php/conf.d/xdebug.ini; \
    echo xdebug.remote_port=9000 >> /usr/local/etc/php/conf.d/xdebug.ini;

RUN    mkdir ~/software && \
    cd  ~/software/ && \
    wget --no-check-certificate http://xdebug.org/files/xdebug-2.4.0rc4.tgz && \
    tar -xvzf xdebug-2.4.0rc4.tgz && \
    cd xdebug-2.4.0RC4 && \
    phpize && \
    ./configure && \
    make && \
    cp modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20151012 && \
    echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so" >> /usr/local/etc/php/php.ini

WORKDIR /var/www/application
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer