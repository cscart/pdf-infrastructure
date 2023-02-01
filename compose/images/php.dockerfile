FROM php:genworker-alpine
#
ARG PROJECT=pdf
ARG PROJECT_HOME=/var/www/html/genworker
#
COPY ${PROJECT} ${PROJECT_HOME}
COPY supervisord.conf /etc/supervisord.conf
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

#
WORKDIR ${PROJECT_HOME}/app
RUN mkdir -m777 ${PROJECT_HOME}/app/db \
  && curl -o composer.phar https://getcomposer.org/composer.phar \
  && php composer.phar install \
  && npm install --prefix ${PROJECT_HOME}/app
