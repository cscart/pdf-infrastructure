FROM php:genworker-alpine
#
ARG PROJECT=pdf
ARG PROJECT_HOME=/var/www/html/genworker
ARG FONTS_CONF=91-wysiwyg.conf
ARG FONTS_CONF_HOME=/etc/fonts/conf.d
#
COPY ${PROJECT} ${PROJECT_HOME}
COPY ${FONTS_CONF} ${FONTS_CONF_HOME}
#
WORKDIR ${PROJECT_HOME}/app
RUN mkdir -m777 ${PROJECT_HOME}/app/db \
  && curl -o composer.phar https://getcomposer.org/composer.phar \
  && php composer.phar install \
  && npm install --prefix ${PROJECT_HOME}
