# genworker-service
HTML to PDF service for converter.cart-services.com

Copy project https://github.com/bzzeke/pdf/ to `image` directory.

In `pdf` directory copy `local_conf.php.dist` to `local_conf.php`.

Change line `$config['wk_bin']`, set path to binary `'/usr/bin/wkhtmltopdf'`.

In `compose` directory copy `.env.dist` to `.env`, set your values.

Run `make gw_base` in root directory for image building.

Run `make gw_prod` for start project containers.
