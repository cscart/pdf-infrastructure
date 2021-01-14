FROM nginx:genworker-alpine
#
ARG PROJECT=pdf
ARG PROJECT_HOME=/var/www/html/genworker
#
COPY ${PROJECT} ${PROJECT_HOME}