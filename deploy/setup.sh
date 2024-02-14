#!/usr/bin/env bash

echo "start."

if php artisan migrate --force; then
    echo "Migration successful!!"
    apache2-foreground

else
    echo "Migration failed"
    exit 1
fi
