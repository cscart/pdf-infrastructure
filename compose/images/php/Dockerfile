FROM alpine:3.9
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8
ENV WKH_DEPS \
		gtk+ \
		openssl \
		glib \
		dbus \
		xvfb \
		font-noto

ARG PHP_VERSION=7.1.10

ARG PHP_URL="https://secure.php.net/get/php-${PHP_VERSION}.tar.xz/from/this/mirror"
ARG PHP_ASC_URL=""
ARG PHP_SHA256=""
ARG PHP_MD5=""


ENV PHP_INI_DIR /usr/local/etc/php
ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=daemon --with-fpm-group=daemon
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"
ENV PHPIZE_DEPS \
		autoconf \
		dpkg-dev dpkg \
		file \
		g++ \
		gcc \
		libc-dev \
		make \
		pcre-dev \
		pkgconf \
		re2c
#Install not patched wkhtmltopdf
RUN apk add --update wkhtmltopdf
#Installing base packages
RUN apk add --no-cache --virtual .persistent-deps \
		ca-certificates \
		curl \
		tar \
		xz \
		openssl \
    && mkdir -p $PHP_INI_DIR/conf.d
#Checking php package.
RUN set -xe; \
	apk add --no-cache --virtual .fetch-deps \
		gnupg \
	; \
	mkdir -p /usr/src; \
	cd /usr/src; \
	curl -fsSL -o php.tar.xz "$PHP_URL"; \
	apk del .fetch-deps

COPY docker-php-* /usr/local/bin/
COPY wkhtmltopdf /usr/bin/wkhtmltopdf-origin
COPY wkhtmltox.so.0.12.5 /usr/lib/
#Building PHP
RUN set -xe \
	&& apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
		coreutils \
		curl-dev \
		libedit-dev \
		openssl-dev \
		libxml2-dev \
		sqlite-dev \
		libstdc++ \
    && export CFLAGS="$PHP_CFLAGS" \
		      CPPFLAGS="$PHP_CPPFLAGS" \
		      LDFLAGS="$PHP_LDFLAGS" \
	&& docker-php-source extract \
	&& cd /usr/src/php \
	&& gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& ./configure \
		--build="$gnuArch" \
		--with-config-file-path="$PHP_INI_DIR" \
		--with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
		--disable-cgi \
		--enable-ftp \
		--enable-mbstring \
		--enable-mysqlnd \
		--with-curl \
		--with-libedit \
		--with-openssl \
		--with-zlib \
		--with-pcre-regex=/usr \
		$PHP_EXTRA_CONFIGURE_ARGS \
	&& make -j "$(nproc)" \
	&& make install \
	&& { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
	&& make clean \
	&& cd / \
	&& docker-php-source delete \
	&& runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)" \
	&& apk add --no-cache --virtual .php-rundeps $runDeps \
#Installing modules
	&& docker-php-ext-install -j "${NPROC}" \
		pdo pdo_sqlite \
#Installing wkhtmltopdf deps
	&& echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
        && apk add $WKH_DEPS --update --no-cache \
#Supervisord install
	&& apk add --no-cache supervisor \
#Prepare wkhtmltop
	&& echo $'#!/usr/bin/env sh\n\
DISPLAY=:0.0 wkhtmltopdf-origin $@ ' > /usr/bin/wkhtmltopdf \
	&& chmod +x /usr/bin/wkhtmltopdf \
	&& dbus-uuidgen > /var/lib/dbus/machine-id \
#
#Clean
	&& apk del .build-deps \
	&& rm -rf /tmp/pear ~/.pearrc
#
ENTRYPOINT ["docker-php-entrypoint"]
#Preparing php-fpm
RUN set -ex \
	&& cd /usr/local/etc \
	&& if [ -d php-fpm.d ]; then \
		sed 's!=NONE/!=!g' php-fpm.conf.default | tee php-fpm.conf > /dev/null; \
		cp php-fpm.d/www.conf.default php-fpm.d/www.conf; \
	else \
		mkdir php-fpm.d; \
		cp php-fpm.conf.default php-fpm.d/www.conf; \
		{ \
			echo '[global]'; \
			echo 'include=etc/php-fpm.d/*.conf'; \
		} | tee php-fpm.conf; \
	fi \
	&& { \
		echo '[global]'; \
		echo 'error_log = /proc/self/fd/2'; \
		echo; \
		echo '[www]'; \
		echo '; if we send this to /proc/self/fd/1, it never appears'; \
		echo 'access.log = /proc/self/fd/2'; \
		echo; \
		echo 'clear_env = no'; \
		echo; \
		echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
		echo 'catch_workers_output = yes'; \
	} | tee php-fpm.d/docker.conf \
	&& { \
		echo '[global]'; \
		echo 'daemonize = no'; \
		echo; \
		echo '[www]'; \
		echo 'listen = [::]:9000'; \
	} | tee php-fpm.d/zz-docker.conf

RUN apk --no-cache add msttcorefonts-installer fontconfig && \
    update-ms-fonts && \
    fc-cache -f

COPY supervisord.conf /etc/supervisord.conf
EXPOSE 9000
CMD /usr/bin/supervisord -c /etc/supervisord.conf
