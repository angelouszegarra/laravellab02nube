# rebuild.ps1
composer install --no-dev --optimize-autoloader
php artisan optimize:clear
php artisan optimize
