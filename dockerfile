# Imagen oficial de PHP 8.3 con FPM
FROM php:8.3-fpm-alpine

# Instalar dependencias y extensiones requeridas
RUN apk add --no-cache \
    nginx \
    supervisor \
    libzip-dev \
    libpng-dev \
    nodejs \
    npm \
    && docker-php-ext-install pdo pdo_mysql zip gd opcache

# Configurar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Directorio de trabajo
WORKDIR /var/www/html

# Copiar archivos necesarios
COPY . .

# Instalar dependencias y compilar assets
RUN composer install --no-dev --optimize-autoloader \
    && npm install && npm run build \
    && chown -R www-data:www-data storage bootstrap/cache

# Configuraciones
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Puerto y comando de inicio
EXPOSE 8000
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
