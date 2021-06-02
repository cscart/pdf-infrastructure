# genworker-service
HTML to PDF service for converter.cart-services.com

Starting project from old image (registry login required):

In `compose` directory copy `.env.dist` to `.env`, set your values (REGISTRY required, must logged in registry account).

Copy project https://github.com/cscart/pdf to `image` directory.

In `pdf` directory copy `local_conf.php.dist` to `local_conf.php`.

Change line `$config['wk_bin']`, set path to binary `'/usr/bin/wkhtmltopdf'`.

Run `make gw_registry` for use old images from registry.

Run `make gw_prp_registry` for install composer packages.

Build new images (not all cases tested!!!):

Copy project https://github.com/cscart/pdf to `image` directory.

In `pdf` directory copy `local_conf.php.dist` to `local_conf.php`.

Change line `$config['wk_bin']`, set path to binary `'/usr/bin/wkhtmltopdf'`.

In `compose` directory copy `.env.dist` to `.env`, set your values.

Run `make gw_base` in root directory for image building.

Run `make gw_prod` for start project containers.

Run `make gw_prp` for install composer packages.
