FROM composer:2 AS composer
FROM php:8.4-fpm-alpine3.20

# Install Composer
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# Install dependencies
RUN apk add --no-cache \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    freetype-dev \
    libxpm-dev \
    libvpx-dev \
    libzip-dev \
    libxml2-dev \
    mariadb-connector-c-dev \
    autoconf \
    g++ \
    make \
    bash \
    && docker-php-ext-configure gd \
        --with-jpeg \
        --with-webp \
        --with-freetype \
    && docker-php-ext-install -j$(nproc) \
        gd \
        soap \
        pdo_mysql \
        opcache \
        zip \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del autoconf g++ make \
    && rm -rf /tmp/* /var/cache/apk/*