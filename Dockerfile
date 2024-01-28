FROM php:8.1-apache

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get update \
    && apt-get install -y unzip libpq-dev git \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install mysqli pdo_mysql opcache \
    && a2enmod rewrite

COPY ./deploy/php.ini /usr/local/etc/php/
COPY ./deploy/000-default.conf /etc/apache2/sites-available/

COPY --from=node:18.16 /usr/local/bin /usr/local/bin
COPY --from=node:18.16 /usr/local/lib /usr/local/lib
COPY composer.json composer.json
COPY composer.lock composer.lock

WORKDIR /var/www/html

COPY . ./

RUN composer install \
    && composer dump-autoload \
    && npm install \
    && npm run build \
    && chmod -R 777 storage \
    && chmod -R 777 bootstrap \
    && php -r "file_exists('.env') || copy('.env.example', '.env');" \
    && php artisan key:generate \
    && sed -i 's/DB_CONNECTION=/DB_CONNECTION=mysql/' .env \
    && sed -i 's/DB_HOST=/DB_HOST=db/' .env \
    && sed -i 's/DB_DATABASE=/DB_DATABASE=test_laravel/' .env \
    && sed -i 's/DB_PASSWORD=/DB_PASSWORD=rootpw/' .env \
    && php artisan optimize

EXPOSE 80

ENTRYPOINT ["./deploy/entrypoint.sh"]