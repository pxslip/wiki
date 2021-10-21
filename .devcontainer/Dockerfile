# [Choice] PHP version (use -bullseye variants on local arm64/Apple Silicon): 8, 8.0, 7, 7.4, 7.3, 8-bullseye, 8.0-bullseye, 7-bullseye, 7.4-bullseye, 7.3-bullseye, 8-buster, 8.0-buster, 7-buster, 7.4-buster, 7.3-buster
ARG VARIANT=8-fpm-bullseye
FROM php:${VARIANT}

# Install MariaDB client
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends librsvg2-bin imagemagick python3 libicu-dev libonig-dev mariadb-client nginx \ 
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install php-mysql driver
RUN docker-php-ext-install -j "$(nproc)" intl mbstring mysqli opcache pdo pdo_mysql\
    && pecl install APCu-5.1.20\
    && docker-php-ext-enable apcu\
    && rm -r /tmp/pear

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

COPY nginx.conf /etc/nginx/sites-available/default
RUN service nginx start


# Set the mediawiki version for the installer 
ARG MEDIAWIKI_VERSION=1.36.2
ENV MEDIAWIKI_VERSION=${MEDIAWIKI_VERSION}
ARG CARGO_VERSION=3.0
ENV CARGO_VERSION=${CARGO_VERSION}
