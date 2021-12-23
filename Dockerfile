FROM debian:bullseye-slim

MAINTAINER Théo BARRAGUE <theo@barrague.fr>

ENV NGINX_VERSION 1.20.0
ENV HTTP_AUTH_PAM_VERSION 1.5.3 
ENV HEADERS_MORE_VERSION 0.33
ENV SECURITY_HEADERS_VERSION 0.0.9
ENV BROTLI_VERSION 1.0.0rc
ENV COOKIE_FLAG_VERSION 1.1.0
ENV HTTP_GEOIP2_VERSION 3.3

RUN apt-get update ; \ 
    apt-get install -y \
      build-essential \
      libpcre3-dev \
      libssl-dev \
      zlib1g-dev \
      libbrotli-dev \
      libmaxminddb-dev \
      wget && \
    rm -rf /var/lib/apt/lists/* && \
    wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && \
    tar -zxvf nginx-$NGINX_VERSION.tar.gz && \
    rm nginx-$NGINX_VERSION.tar.gz && \
    wget https://github.com/sto/ngx_http_auth_pam_module/archive/refs/tags/v$HTTP_AUTH_PAM_VERSION.tar.gz -O ngx_http_auth_pam_module-$HTTP_AUTH_PAM_VERSION.tar.gz && \
    tar -zxvf ngx_http_auth_pam_module-$HTTP_AUTH_PAM_VERSION.tar.gz && \ 
    rm ngx_http_auth_pam_module-$HTTP_AUTH_PAM_VERSION.tar.gz && \
    wget https://github.com/openresty/headers-more-nginx-module/archive/refs/tags/v$HEADERS_MORE_VERSION.tar.gz -O headers-more-nginx-module-$HEADERS_MORE_VERSION.tar.gz && \
    tar -zxvf headers-more-nginx-module-$HEADERS_MORE_VERSION.tar.gz && \
    rm headers-more-nginx-module-$HEADERS_MORE_VERSION.tar.gz && \
    wget https://github.com/GetPageSpeed/ngx_security_headers/archive/refs/tags/$SECURITY_HEADERS_VERSION.tar.gz -O ngx_security_headers-$SECURITY_HEADERS_VERSION.tar.gz && \
    tar -zxvf ngx_security_headers-$SECURITY_HEADERS_VERSION.tar.gz && \
    rm ngx_security_headers-$SECURITY_HEADERS_VERSION.tar.gz && \
    wget https://github.com/google/ngx_brotli/archive/refs/tags/v$BROTLI_VERSION.tar.gz -O ngx_brotli-$BROTLI_VERSION.tar.gz && \
    tar -zxvf ngx_brotli-$BROTLI_VERSION.tar.gz && \
    rm ngx_brotli-$BROTLI_VERSION.tar.gz && \ 
    wget https://github.com/AirisX/nginx_cookie_flag_module/archive/refs/tags/v$COOKIE_FLAG_VERSION.tar.gz -O nginx_cookie_flag_module-$COOKIE_FLAG_VERSION.tar.gz && \
    tar -zxvf nginx_cookie_flag_module-$COOKIE_FLAG_VERSION.tar.gz && \
    rm nginx_cookie_flag_module-$COOKIE_FLAG_VERSION.tar.gz && \
    wget https://github.com/leev/ngx_http_geoip2_module/archive/refs/tags/$HTTP_GEOIP2_VERSION.tar.gz -O ngx_http_geoip2_module-$HTTP_GEOIP2_VERSION.tar.gz && \
    tar -zxvf ngx_http_geoip2_module-$HTTP_GEOIP2_VERSION.tar.gz && \
    rm ngx_http_geoip2_module-$HTTP_GEOIP2_VERSION.tar.gz && \
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
      --add-module=../ngx_http_auth_pam_module-$HTTP_AUTH_PAM_VERSION \
      --add-module=../headers-more-nginx-module-$HEADERS_MORE_VERSION \
      --add-module=../ngx_security_headers-$SECURITY_HEADERS_VERSION \
      --add-module=../ngx_brotli-$BROTLI_VERSION \
      --add-module=../nginx_cookie_flag_module-$COOKIE_FLAG_VERSION \
      --add-module=../ngx_http_geoip2_module-$HTTP_GEOIP2_VERSION && \
    apt-get remove -y \
      build-essential \
      libpcre3-dev \
      libssl-dev \
      zlib1g-dev \
      libbrotli-dev \
      libmaxminddb-dev \
      wget && \
    apt-get autoremove -y
