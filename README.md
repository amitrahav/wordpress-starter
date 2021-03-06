# Project setup instructions

## Quick start
`curl -L https://api.github.com/repos/amitrahav/wordpress-starter/tarball | tar xzf - --strip 1`

## Dependencies

1. Appache proxy on localhost _or_ Docker
2. [Composer](https://getcomposer.org/download/)

## Credits

- this template based on [justCpded / WordPress Starter](https://github.com/justcoded/wordpress-starter) for composer support
- this template also use [visiblevc/wordpress-starter](https://github.com/visiblevc/wordpress-starter/tree/master) for docker support.
- .gitignore ready for wp-engine git push without core wp.

## Auto install
You can auto install all the basic goodies by running `./autoinstall`.
Its includes:

1. New Theme - with scripts and desired plugins.
2. Existing theme - that you can pull form git repo and continue working on it within this framework inside the docker with composer.
3. (Future feature) Plugin - initialize plugin

## Existing Project

1. Navigate to project root directory:

   ```bash
   cd /path/to/your/project/folder/
   ```

2. Clone zipped specific repo files:

   ```bash
   $ curl https://codeload.github.com/amitrahav/wordpress-starter/tar.gz/master | tar -xz --strip 1
   ```

3. Install all requirements from composer

   - By default, ACF PRO is a must use plugin. in order for it to be installed you should add a key to .env file.

   ```bash
   mv .env.example .env
   composer install && composer update
   ```

4. Ignore all ops files by adding

   ```bash
   $ echo '\n/data/\n/data/logs\n!/data/.gitkeep\n!/data/logs/.gitkeep\nenvironments\nscripts\n*.example\n*.lock\nlogs.ini\nrobots.txt\n# HERE GOES YOUR APP EXCEPTION' >> .gitignore
   ```

### Database setup

- save your db sql dump at data folder (this is enough for Docker)

- Local Proxy:

  - wp-cli import mysql dump: `$wp db import mysql.sql` [requires local wp-cli install](https://wp-cli.org/)

  - with phpmyadmin

## Development

### Switch to latest branch

- master - stable production copy,
- develop - current development copy

```bash
git checkout <branch-name>
```

### Create new branch for your changes

```bash
git checkout -b <issue#>_<short descr></short>
```

### Create your environment

1. Update environment variables in `.env` file:

- `DB_NAME` - Database name
- `DB_USER` - Database user
- `DB_PASSWORD` - Database password
- `DB_HOST` - Database host
- `WP_ENV` - Set to environment (`development`, `staging`, `production`)
- `WP_HOME` - Full URL to WordPress home (http://example.com)
- `ACF_PRO_KEY` - Acf key for installing the full version of acf plugin

### Setup VScode tasks

If you want you can use the .vscode/tasks.json file for auto processes using vscode tasks.
you need to install globally node-sass `npm i -g node-sass` and change path to your project (theme or plugin) sass and css files on the tasks file.

### Require Wp plugins and themes

1. use [composer.json or composer cli](https://wpackagist.org/)
2. if using docker, add themes or plugins to script/init.sh file to activate on wp cli when docker is up

### Add Acf as a Must-Use Plugins

run this after you run `$composer install && composer update`

```bash
echo "<?php require_once(__DIR__ . '/advanced-custom-fields-pro/acf.php');" > wp-content/mu-plugins/advanced-custom-fields-pro.php
```
