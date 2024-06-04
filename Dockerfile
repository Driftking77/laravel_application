# Stage 1: Build
FROM composer:2.1 AS build

# Set working directory
WORKDIR /app

# Copy composer.json and composer.lock to the working directory
COPY composer.json composer.lock ./

# Install dependencies
RUN composer install --no-dev --no-scripts --no-progress --no-interaction

# Copy application code to the working directory
COPY . .

# Run Laravel optimization commands
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

# Stage 2: Production
FROM php:8.1-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    bash \
    mysql-client \
    nodejs \
    npm \
    git \
    icu-dev \
    libzip-dev \
    libpng-dev \
    oniguruma-dev \
    libxml2-dev \
    zip \
    unzip

# Install PHP extensions
RUN docker-php-ext-install \
    pdo_mysql \
    zip \
    exif \
    pcntl \
    bcmath \
    gd \
    intl \
    mbstring \
    xml

# Copy the optimized Laravel application from the build stage
COPY --from=build /app /var/www/html

# Set working directory
WORKDIR /var/www/html

# Copy the entrypoint script
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]


