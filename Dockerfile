FROM php:7.2-fpm-alpine
MAINTAINER vidy videni <vidy.videni@gmail.com>

ENV TZ UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone

# change source to aliyun mirror
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# tools
RUN apk add --update --no-cache \
  vim wget \
  net-tools openssh-client git

# intl, zip, opcache
RUN apk add --update --no-cache libintl icu icu-dev zlib-dev && \
    docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" intl opcache zip

# gd, iconv, exif
RUN apk add --update --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
    docker-php-ext-configure gd \
      --with-gd \
      --with-freetype-dir=/usr/include/  \
      --with-png-dir=/usr/include/  \
      --with-jpeg-dir=/usr/include/  && \
    docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" gd iconv exif

# pdo_pgsql
RUN apk add --update --no-cache postgresql-dev && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)"  pdo_pgsql pdo

# nginx
RUN apk add --update --no-cache openssl curl ca-certificates && \
    printf "%s%s%s\n" \
    "http://nginx.org/packages/alpine/v" \
    `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
    "/main" \
    | tee -a /etc/apk/repositories && \
    curl -o /etc/apk/keys/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub

RUN apk add --update --no-cache nginx supervisor && \
    rm -rf /tmp/* /var/tmp/*  && \
    ln -sf /proc/1/fd/1 /var/log/nginx/access.log  && \
    ln -sf /proc/1/fd/2 /var/log/nginx/error.log

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.6.5

RUN rm -rf /etc/nginx/sites-enabled/* /etc/nginx/conf.d/* /usr/local/etc/php-fpm.d/*
ADD nginx/default.conf /etc/nginx/conf.d/

COPY php/php.ini        /usr/local/etc/php/conf.d/
COPY php/php-fpm.conf    /usr/local/etc/php-fpm.d/www.conf

# setup startup script
ADD nginx.sh /nginx.sh
ADD php-fpm.sh /php-fpm.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# ports
EXPOSE 80

ENTRYPOINT ["sh", "/run.sh"]
