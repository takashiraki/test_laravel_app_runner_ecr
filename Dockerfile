FROM php:8.3-apache

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get update \
    && apt-get install -y unzip libpq-dev git vim\
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install mysqli pdo_mysql opcache \
    && a2enmod rewrite

COPY ./deploy/php.ini /usr/local/etc/php/
COPY ./deploy/000-default.conf /etc/apache2/sites-available/

COPY --from=node:18.16 /usr/local/bin /usr/local/bin
COPY --from=node:18.16 /usr/local/lib /usr/local/lib

WORKDIR /var/www/html

COPY . ./

# RUN useradd -ms /bin/bash developer \
#     && chown -R developer:developer /var/www/html

# USER developer

RUN composer install \
    && composer dump-autoload \
    && npm install \
    && npm run build \
    && chmod -R 777 storage \
    && chmod -R 777 bootstrap \
    && chmod -R 755 deploy \
    && chmod +x deploy/setup.sh \
    && php -r "file_exists('.env') || copy('.env.example', '.env');" \
    && php artisan key:generate

ENTRYPOINT [ "./deploy/setup.sh" ]