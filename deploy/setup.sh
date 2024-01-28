#!/usr/bin/env bash

echo "start."

composer install
composer dump-autoload

npm install
npm run build

chmod -R 777 storage
chmod -R 777 bootstrap

php -r "file_exists('.env') || copy('.env.example', '.env');"
php artisan key:generate

php artisan migrate
