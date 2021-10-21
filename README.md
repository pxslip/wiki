# Project Path of Exile Wiki

A community effort to move the contents of the Wiki and update it to the current patch.

Website: [Project Path of Exile Wiki](https://poewiki.net)

## Devcontainer Set up

You may need to update `www/LocalSettings.php` if you change the port assigned to this container

### Database Credentials

- user: root
- pass: mariadb
- database: mariadb
- table prefix: poe\_

### Wiki Account

- user: admin
- password: PoEWikiAdmin

### Wiki Bot Account

- user: Admin
- password: pypoe@g70c02ll1skp31a2p67d6vvhcfh77vsb

## Non-devcontainer Set up

1. Update `.devcontainer/LocalSettings.php` by changing the following:

   - Change the db credentials (lines 55-59) to your db settings
   - Update the `$wgServer` value to your local url and port

2. Copy `.devcontainer/LocalSettings.php` to `./www`

3. Run `.devcontainer/install-media-wiki.sh`

## Importing the dump

**READ [before-import.md](./before-import.md) before importing the dump**

Follow the import instructions here: https://www.mediawiki.org/wiki/Manual:Importing_XML_dumps

Once you have imported the dump and have ~76,541 pages populated on the wiki, you must recreate the Cargo tables. There are 2 methods to do this.

### Method 1: Manually

Go to https://pathofexile.fandom.com/wiki/Special:CargoTables and click on the links that are to the right of the table name.

For example:

> amulets (View | Drilldown) - 133 rows (Declared by Template:Item/cargo/amulets, attached by Template:Item/cargo/attach/amulets)

Copy "Template:Item/cargo/amulets" and add it the the URL on your installation. This takes you to a template page which should have a message saying "This template declares the cargo table 'amulets'. The tables does not exist yet."

Edit the page without making any changes, just save. A new button should appear on the top right labeled "Create data tables". Click it and create the table.

Do the same steps for the attached Template (note: some have and some dont have attach templates, some have the attach statement in the same template as the declare, etc.)

### Method 3: Using the CLI

If you have access to the CLI you can use the following script to automate the recreation of the cargo tables

```sh
while read tpl; do
  php www/maintenance/getText.php "$tpl" | php www/maintenance/edit.php "$tpl"
done < .devcontainer/cargo-templates.txt
# tell cargo to recreate the tables for data
php www/extensions/Cargo/maintenance/cargoRecreateData.php
```
