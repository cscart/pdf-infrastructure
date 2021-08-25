#!/bin/sh
find /tmp/ -mmin +60 -name "php*" | xargs --no-run-if-empty rm
find /var/www/html/genworker/app/files -mmin +60 -name "*.pdf" | xargs --no-run-if-empty rm
find /var/www/html/genworker/app/files -mmin +60 -name "*.html" | xargs --no-run-if-empty rm
sleep 60
