# Project setup instructions

## Dependencies

1. Appache proxy on localhost _or_ Docker
2. [Composer](https://getcomposer.org/download/)

## Credits

- this template based on [justCpded / WordPress Starter](https://github.com/justcoded/wordpress-starter) for composer support
- this template also use [visiblevc/wordpress-starter](https://github.com/visiblevc/wordpress-starter/tree/master) for docker support.
- .gitignore ready for wp-engine git push without core wp.

## Existing Project

1. Navigate to project root directory:

```bash
cd /path/to/your/project/folder/
```

2. Clone zipped specific repo files:

```bash
$ curl https://codeload.github.com/amitrahav/wordpress-starter/tar.gz/master | tar -xz --strip 1
```

3. If necessary remove old structure wp

```bash
$ rm -rf wp-admin wp-includes license.txt wp-activate.php wp-blog-header.php wp-comments-post.php wp-cron.php wp-links-opml.php wp-load.php wp-login.php wp-mail.php wp-settings.php wp-signup.php wp-trackback.php xmlrpc.php
```

4. Install all requirements from composer

```bash
composer update
```

5. Ignore all ops files by adding

```bash
echo "/data/\n /data/logs\n !/data/.gitkeep\n !/data/logs/.gitkeep\n environments\n scripts\n *.example\n *.lock\n logs.ini\n robots.txt\n $(cat .gitignore)" > .gitignore
```

## New Project

1. create new project:

```bash
composer create-project amitrahav/wordpress-starter <name-of-project> && cd <name-of-project>
```

2. Download wp core with composer

```bash
composer update
```

3. start developing!

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

### Require Wp plugins and themes

1. use [composer.json or composer cli](https://wpackagist.org/)
2. if using docker, add themes or plugins to script/init.sh file to activate on wp cli when docker is up
