# Stage 1: PHP dependencies
FROM php:8.3-cli AS php-builder

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libzip-dev && \
    docker-php-ext-install zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app

COPY . .

RUN composer install --no-dev --optimize-autoloader


# Stage 2: build assets
FROM node:18 AS frontend-builder

WORKDIR /app

COPY --from=php-builder /app /app

RUN npm install && npm run build


# Stage 3: Runtime
FROM php:8.3-fpm

WORKDIR /var/www/html

COPY --from=frontend-builder /app /var/www/html

COPY ./docker-env/php/php.ini /usr/local/etc/php/php.ini

EXPOSE 9000

CMD ["php-fpm"]