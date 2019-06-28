FROM alpine:3.9.4

ENV DEBIAN_FRONTEND=noninteractive
ENV NGINX_VERSION 1.17.0

### install nginx & php packages
RUN apk update && apk upgrade && \
  apk add --no-cache nginx curl && \
  adduser -D -g 'www' www && \
  mkdir -p /var/www/html && \
  chown -R www:www /var/www && \
  chown -R www:www /var/lib/nginx && \
  chown -R www:www /var/tmp/nginx && \
  ln -sf /proc/self/fd/1 /var/log/nginx/access.log && \
  ln -sf /proc/self/fd/2 /var/log/nginx/error.log && \
  apk add --no-cache bash \
  grep \
  findutils \
  pciutils \
  usbutils \
  util-linux \
  php7 \
  php7-bcmath \
  php7-common \ 
  php7-curl \
  php7-dom \
  php7-exif \
  php7-fpm \
  php7-gd \
  php7-imagick \
  php7-json \
  php7-mysqli \
  php7-mbstring \
  php7-opcache \
  php7-phar \
  php7-redis \
  php7-tokenizer \
  php7-xml \
  php7-zlib && \
  sed -i 's/user = nobody/user = www/g' /etc/php7/php-fpm.d/www.conf && \
  sed -i 's/group = nobody/group = www/g' /etc/php7/php-fpm.d/www.conf && \
  sed -i 's#listen = 127.0.0.1:9000#listen = /var/run/php-fpm.sock#g' /etc/php7/php-fpm.d/www.conf && \
  sed -i 's/;listen.owner = nobody/listen.owner = www/' /etc/php7/php-fpm.d/www.conf && \
  sed -i 's/;listen.group/listen.group/' /etc/php7/php-fpm.d/www.conf && \
  sed -i 's/;listen.mode/listen.mode/' /etc/php7/php-fpm.d/www.conf && \
  sed -i 's/;clear_env/clear_env/' /etc/php7/php-fpm.d/www.conf && \
  ln -sf /proc/self/fd/2 /var/log/php7/error.log

COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/nginx.vh.default.conf /etc/nginx/conf.d/default.conf
COPY ./config/gzip.conf /etc/nginx/conf.d/gzip.conf

EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
