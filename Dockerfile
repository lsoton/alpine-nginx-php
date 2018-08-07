FROM alpine:3.8

MAINTAINER Leonardo Soto, https://github.com/lsoton

RUN apk update
#    apk wget tar make gcc g++ zlib-dev libressl-dev pcre-dev fcgi-dev jpeg-dev libmcrypt-dev bzip2-dev curl-dev libpng-dev libxslt-dev postgresql-dev perl-dev file acl-dev libedit-dev icu-dev icu-libs && \
    #apk zip unzip curl lynx sudo openssh-server nano vi lynx

#Usuario SSH
#RUN  apk nginx

# Instalar php7-fpm
RUN apk --no-cache add php7 php7-fpm php7-mysqli php7-json php7-openssl php7-curl \
    php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype \
    php7-mbstring php7-gd supervisor nginx

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/fpm-pool.conf
COPY config/php.ini /etc/php7/conf.d/php.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#
RUN mkdir -p /var/www/html
WORKDIR /var/www/html
COPY src/ /var/www/html/

EXPOSE 80 443 22

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
