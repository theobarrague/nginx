FROM debian:bullseye-slim

MAINTAINER Théo BARRAGUE <theo@barrague.fr>

ENV NGINX_VERSION 1.20.0
ENV HEADERS_MORE_VERSION 0.33
ENV BROTLI_VERSION 1.0.0rc

RUN apt-get update ; \ 
    apt-get install -y \
      build-essential \
      libpcre3-dev \
      libssl-dev \
      zlib1g-dev \
      libbrotli-dev \
      wget && \
    rm -rf /var/lib/apt/lists/* && \
    wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && \
    tar -zxvf nginx-$NGINX_VERSION.tar.gz && \
    rm nginx-$NGINX_VERSION.tar.gz && \
    wget https://github.com/openresty/headers-more-nginx-module/archive/refs/tags/v$HEADERS_MORE_VERSION.tar.gz -O headers-more-nginx-module-$HEADERS_MORE_VERSION.tar.gz && \
    tar -zxvf headers-more-nginx-module-$HEADERS_MORE_VERSION.tar.gz && \
    rm headers-more-nginx-module-$HEADERS_MORE_VERSION.tar.gz && \
    wget https://github.com/google/ngx_brotli/archive/refs/tags/v$BROTLI_VERSION.tar.gz -O ngx_brotli-$BROTLI_VERSION.tar.gz && \
    tar -zxvf ngx_brotli-$BROTLI_VERSION.tar.gz && \
    rm ngx_brotli-$BROTLI_VERSION.tar.gz && \ 
    cd nginx-$NGINX_VERSION && \
    ./configure \
      --prefix=/var/www/html \
      --sbin-path=/usr/sbin/nginx \
      --conf-path=/etc/nginx/nginx.conf \
      --http-log-path=/var/log/nginx/access.log \
      --error-log-path=/var/log/nginx/error.log \
      --modules-path=/etc/nginx/modules \
      --lock-path=/var/lock/nginx.lock \
      --pid-path=/var/run/nginx.pid \
      --with-pcre \
      --with-http_ssl_module \
      --with-http_v2_module \
      --add-module=../headers-more-nginx-module-$HEADERS_MORE_VERSION \
      --add-module=../ngx_brotli-$BROTLI_VERSION \
    apt-get remove -y \
      build-essential \
      libpcre3-dev \
      libssl-dev \
      zlib1g-dev \
      libbrotli-dev \
      wget && \
    apt-get autoremove -y
