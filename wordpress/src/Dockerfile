FROM mcr.microsoft.com/appsvc/wordpress-alpine-php:latest 

RUN apk add --update-cache \
  sudo

COPY install-plugins.sh /usr/local/bin/install-plugins.sh

RUN chmod +x /usr/local/bin/install-plugins.sh &&\
  cd /home/site/wwwroot &&\
  /usr/local/bin/install-plugins.sh
