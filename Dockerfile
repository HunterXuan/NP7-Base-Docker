FROM php:7.2-apache

LABEL maintainer="endpot@gmail.com"

# install extension
RUN apt-get update \
	&& apt-get install -y git cron libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && :\
    && apt-get install -y libicu-dev \
    && docker-php-ext-install intl \
    && :\
    && apt-get install -y libxml2-dev \
    && apt-get install -y libxslt-dev \
    && docker-php-ext-install soap \
    && docker-php-ext-install xsl \
    && docker-php-ext-install xmlrpc \
    && docker-php-ext-install wddx \
    && :\
    && apt-get install -y libbz2-dev \
    && docker-php-ext-install bz2 \
    && :\
    && docker-php-ext-install zip \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install exif \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install sockets \
    && docker-php-ext-install gettext \
    && docker-php-ext-install shmop \
    && docker-php-ext-install sysvsem \
	&& docker-php-ext-install opcache \
    && :\
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Configuring PHP and Apache
RUN a2enmod rewrite \
	&& cp $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini \
	&& sed -i 's/upload_max_filesize = .*/upload_max_filesize = 8M/' $PHP_INI_DIR/php.ini \
	&& sed -i 's/;opcache.enable=.*/opcache.enable=1/' $PHP_INI_DIR/php.ini  \
	&& sed -i 's/;opcache.memory_consumption=.*/opcache.memory_consumption=64/' $PHP_INI_DIR/php.ini  \
	&& sed -i 's/;opcache.interned_strings_buffer=.*/opcache.interned_strings_buffer=8/' $PHP_INI_DIR/php.ini  \
	&& sed -i 's/;opcache.max_accelerated_files=.*/opcache.max_accelerated_files=1000/' $PHP_INI_DIR/php.ini

# Download and Install Composer
RUN curl -s http://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

WORKDIR /var/www/html
