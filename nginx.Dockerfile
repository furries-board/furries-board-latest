FROM php:8.4-fpm

# 安裝系統工具 + nginx
RUN apt-get update && apt-get install -y \
    nginx \
    vim \
    git \
    unzip \
    curl \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libpq-dev \
    openssl

# 安裝 PHP 擴展
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql zip pdo_pgsql pgsql \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

# 安裝 Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 設定 Xdebug
RUN echo "zend_extension=xdebug.so" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.mode=debug,coverage" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# 複製 nginx 設定檔
COPY ./docker-env/nginx/default.conf /etc/nginx/conf.d/default.conf

WORKDIR /var/www/html

COPY . .

# 調整權限
RUN chown -R www-data:www-data /var/www

EXPOSE 80 443 9000 9003

# 用 bash 同時啟動 php-fpm 和 nginx（用 & 跟 wait 保持 container 不退出）
CMD bash -c "php-fpm & nginx -g 'daemon off;'"
