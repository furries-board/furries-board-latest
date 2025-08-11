# Stage 1: build
FROM php:8.3-cli as builder

RUN apt-get update && \
	apt-get install -y unzip curl npm nodejs

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app

COPY . .

RUN composer install


# Stage 2: deploy
FROM php:8.3-fpm

RUN apt-get update && \
  apt-get install -y nginx supervisor --fix-missing

COPY --from=builder /app /var/www/html

COPY ./docker-env/dev/default.conf /etc/nginx/conf.d/default.conf

COPY ./docker-env/dev/supervisord.conf /etc/supervisord.conf

COPY ./docker-env/php/php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www/html

EXPOSE 80 443

CMD ["supervisord", "-c", "/etc/supervisord.conf"]