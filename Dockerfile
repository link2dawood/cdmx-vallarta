# 420 CDMX / Vallarta - PHP app with Apache
FROM php:8.2-apache

# Install system deps and PHP extensions (split so failures are easier to see)
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libonig-dev \
    zip \
    unzip \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions that don't need configure, then Apache mods (pdo is core, not in ext/)
# Use -j2 to limit memory during build; increase Docker Desktop memory if you hit OOM
RUN docker-php-ext-install -j2 mysqli pdo_mysql zip mbstring \
    && a2enmod rewrite headers

# gd (needs configure); install last so we see if it's the only failure
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j2 gd

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Document root is /var/www/html (default)
WORKDIR /var/www/html

# Copy application (excluding what's in .dockerignore)
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader 2>/dev/null || true

# Allow Apache to write to uploads and other dirs
RUN chown -R www-data:www-data /var/www/html/uploads /var/www/html/images 2>/dev/null || true \
    && chmod -R 755 /var/www/html/uploads /var/www/html/images 2>/dev/null || true

# Entrypoint generates settings/db.php from env and starts Apache
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
