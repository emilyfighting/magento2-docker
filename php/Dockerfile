FROM php:7.1-fpm-jessie
MAINTAINER vidy videni <vidy.videni@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_CODENAME jessie
ENV TZ UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone \
  && dpkg-reconfigure -f noninteractive tzdata

RUN \
  apt-get update && \ 
  apt-get install -y --no-install-recommends \
  curl \
  wget \
  net-tools \ 
  git apt-transport-https apt-utils build-essential

# Node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update &&  apt-get install -y yarn nodejs 
RUN yarn global add gulp 

# PHP
RUN apt-get update && apt-get install -y \
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

COPY php.ini        /usr/local/etc/php/conf.d/
COPY default.conf    /usr/local/etc/php-fpm.d/www.conf

# Composer
RUN php -r 'readfile("https://getcomposer.org/installer");' > composer-setup.php \
  && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
  && rm -f composer-setup.php \
  && chown www-data:www-data /var/www

EXPOSE 9000

ENTRYPOINT ["php-fpm", "-F"]