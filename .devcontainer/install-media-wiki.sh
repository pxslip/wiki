#!/usr/bin/env sh

git clone --depth 1 --branch ${MEDIAWIKI_VERSION} https://gerrit.wikimedia.org/r/mediawiki/core.git www
git -C www submodule update --init --recursive --depth 1
# Add the Cargo extension
git -C www/extensions clone --branch 3.0 --depth 1 https://gerrit.wikimedia.org/r/mediawiki/extensions/Cargo
# Set the secret key in the LocalSettings
echo "Updating LocalSettings.php"
sed -i "s/to_be_replaced_by_sed/$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 64)/" .devcontainer/LocalSettings.php
cp .devcontainer/LocalSettings.php www/LocalSettings.php
### This would be ideal, need to find a storage location for an ~300MB db dump
# mysql --user=root --password=mariadb --host=127.0.0.1 mariadb < .devcontainer.sql
php www/maintenance/update.php
# rm -r www/mw-config
# loop through the cargo templates to update the page_props table
### This is the original setup script, replaced by the DB dump import ###
while read tpl; do
  php www/maintenance/getText.php "$tpl" | php www/maintenance/edit.php "$tpl"
done < .devcontainer/cargo-templates.txt
# tell cargo to recreate the tables for data
echo "SELECT pp_value FROM poe_page_props WHERE pp_propname='CargoTableName'"\
  | mysql --user=root --password=mariadb --host=127.0.0.1 -N mariadb\
  | while read table; do
    php www/extensions/Cargo/maintenance/cargoRecreateData.php --table="$table"
done

# Link the local www folder to where the default apache config is looking
echo "Linking local www as the default DocumentRoot"
sudo chmod a+x "$(pwd)/www"
sudo rm -rf /var/www/html
sudo ln -s "$(pwd)/www" /var/www/html
