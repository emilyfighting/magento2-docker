FROM php:7.1-fpm-jessie
MAINTAINER vidy videni <vidy.videni@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_CODENAME jessie
ENV TZ UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone \
  && dpkg-reconfigure -f noninteractive tzdata

#change apt source
# ADD sources.list /tmp/sources.list
# RUN cat /tmp/sources.list > /etc/apt/sources.list
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-key adv --fetch-keys http://nginx.org/keys/nginx_signing.key

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  vim \
  wget \
  net-tools openssh-client \
  git build-essential\
  yarn nodejs

RUN yarn global add gulp \
   && apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libicu-dev \
        libicu52  \
        libpcre3-dev \
    && docker-php-ext-install iconv \
    && docker-php-ext-install exif \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pdo \
    && docker-php-ext-install intl \
    && docker-php-ext-install opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip  \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN apt-get install -y nginx supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && ln -sf /proc/1/fd/1 /var/log/nginx/access.log \
    && ln -sf /proc/1/fd/2 /var/log/nginx/error.log


# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

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

ENTRYPOINT ["/run.sh"]
