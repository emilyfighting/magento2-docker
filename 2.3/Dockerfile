FROM php:7.3-fpm-alpine
LABEL Author="vidy videni <vidy.videni@gmail.com>"

ENV TZ UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone

# change source to aliyun mirror
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# tools
RUN apk add --update --no-cache \
  vim wget \
  net-tools openssh-client git procps

# Add Build Dependencies
RUN apk add --no-cache  \
    curl \
    g++ \
    gcc \
    gnupg \
    autoconf \
    libgcc \
    make

# install the PHP extensions we need
RUN apk add --no-cache \
		coreutils \
		freetype-dev \
		libjpeg-turbo-dev \
		libjpeg-turbo \
		libpng-dev \
		libzip-dev \
		jpeg-dev \
		icu-dev \
		zlib-dev \
		curl-dev \
		imap-dev \
		libxslt-dev libxml2-dev \
		postgresql-dev \
        libgcrypt-dev \
		oniguruma-dev

RUN	docker-php-ext-configure gd
RUN	docker-php-ext-install gd
RUN	docker-php-ext-configure intl
RUN	docker-php-ext-configure imap
run docker-php-ext-configure zip

RUN docker-php-ext-install -j "$(nproc)" soap imap bcmath mbstring iconv curl sockets
RUN docker-php-ext-install -j "$(nproc)" opcache
RUN docker-php-ext-install -j "$(nproc)" xsl
RUN docker-php-ext-install -j "$(nproc)" exif
RUN docker-php-ext-install -j "$(nproc)" mysqli pdo pdo_mysql
RUN docker-php-ext-install -j "$(nproc)" intl
RUN docker-php-ext-install -j "$(nproc)" zip

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
# RUN { \
# 		echo 'opcache.memory_consumption=128'; \
# 		echo 'opcache.interned_strings_buffer=8'; \
# 		echo 'opcache.max_accelerated_files=4000'; \
# 		echo 'opcache.revalidate_freq=60'; \
# 		echo 'opcache.fast_shutdown=1'; \
# 	} > /usr/local/etc/php/conf.d/opcache-recommended.ini
  
# nginx
RUN apk add --update --no-cache openssl curl ca-certificates && \
    printf "%s%s%s\n" \
    "http://nginx.org/packages/alpine/" \
    `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
    "/main" \
    | tee -a /etc/apk/repositories && \
    curl -o /etc/apk/keys/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub

RUN apk add --update --no-cache nginx supervisor 

# Clear unused dependencies and cached files.
RUN rm -rf /tmp/* /var/tmp/*  && \
    ln -sf /proc/1/fd/1 /var/log/nginx/access.log  && \
    ln -sf /proc/1/fd/2 /var/log/nginx/error.log

# Composer
RUN php -r 'readfile("https://getcomposer.org/installer");' > composer-setup.php \
  && php composer-setup.php --version=1.10.19 --install-dir=/usr/local/bin --filename=composer \
  && rm -f composer-setup.php
RUN rm -rf /etc/nginx/sites-enabled/* /etc/nginx/conf.d/* /usr/local/etc/php-fpm.d/*
ADD nginx/default.conf /etc/nginx/conf.d/

COPY ./php/php.ini        /usr/local/etc/php/conf.d/
COPY ./php/php-fpm.conf    /usr/local/etc/php-fpm.d/www.conf

# setup startup script
RUN mkdir -p /run/nginx /var/tmp/nginx/
ADD ./nginx.sh /nginx.sh
ADD ./php-fpm.sh /php-fpm.sh
ADD ./run.sh /run.sh
RUN chmod 755 /*.sh
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV PATH="./vendor/bin:$PATH"

WORKDIR /var/www/html

# ports
EXPOSE 80

ENTRYPOINT ["/run.sh"]
