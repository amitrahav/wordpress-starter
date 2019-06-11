# Project setup instructions

## Dependencies

1. Appache proxy on localhost _or_ Docker
2. [Composer](https://getcomposer.org/download/)

## Credits

- this template based on [WordPress Starter](https://github.com/justcoded/wordpress-starter) for composer support
- this template also use [visiblevc/wordpress-starter](https://github.com/visiblevc/wordpress-starter/tree/master) for docker support.
- .gitignore ready for wp-engine git push without core wp.

## Existing Project

### 1. Navigate to project and clone git repo:

```bash
cd /path/to/your/project/empty/folder/
git clone http://repository-domain.com/your/project.git
```

## New Project

1. Download wp core with composer

```bash
composer update
```

2. create new project

```bash
composer update
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
