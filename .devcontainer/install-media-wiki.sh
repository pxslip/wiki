#!/usr/bin/env sh
wget "https://github.com/wikimedia/mediawiki/archive/refs/tags/${MEDIAWIKI_VERSION}.tar.gz"
tar -xvf "${MEDIAWIKI_VERSION}.tar.gz" -C www/ --strip-components=1
composer install
rm "${MEDIAWIKI_VERSION}.tar.gz"

# Set the secret key in the LocalSettings
sed -i "s/to_be_replaced_by_sed/$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 64)/" .devcontainer/LocalSettings.php
cat .devcontainer/local-settings-append.txt >> .devcontainer/LocalSettings.php
cp .devcontainer/LocalSettings.php www/LocalSettings.php
rm -r www/mw-config

# Link the local www folder to where the default apache config is looking
sudo chmod a+x "$(pwd)/www"
sudo rm -rf /var/www/html
sudo ln -s "$(pwd)/www" /var/www/html
