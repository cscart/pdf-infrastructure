FROM node:18-alpine as node
FROM php:8.1-fpm-alpine

COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin
COPY garbage_cleaner.sh /usr/local/bin/

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

RUN apk add --no-cache $PHPIZE_DEPS \
    && docker-php-ext-install opcache \
    && apk del $PHPIZE_DEPS

RUN apk add --no-cache supervisor libstdc++ && apk add --no-cache libgcc

COPY supervisord.conf /etc/supervisord.conf
EXPOSE 9000
CMD /usr/bin/supervisord -c /etc/supervisord.conf
