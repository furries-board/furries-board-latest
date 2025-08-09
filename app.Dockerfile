# Stage 1: Build frontend assets
FROM node:22 AS frontend

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Build PHP-FPM image
FROM php:8.4-fpm

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip curl libfreetype6-dev libjpeg62-turbo-dev libpng-dev libzip-dev libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql zip pdo_pgsql pgsql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

COPY . .

# Copy built assets from frontend stage
COPY --from=frontend /app/public/build /var/www/html/public/build

# Laravel install
RUN composer install --no-dev --optimize-autoloader \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# 調整權限
RUN chown -R www-data:www-data /var/www

EXPOSE 9000

CMD ["php-fpm"]
