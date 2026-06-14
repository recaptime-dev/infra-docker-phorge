FROM alpine:3.24

# Install dependencies
# hadolint ignore=DL3018
RUN apk update && apk upgrade \
  && apk add --no-cache \
    autoconf \
    bash \
    ca-certificates \
    curl \
    gcc \
    git \
    git-lfs \
    git-daemon \
    git-subtree \
    git-email \
    gnupg \
    make \
    musl-dev \
    shadow \
    pkgconf \
    sudo \
    procps \
    openssh \
    php83 \
    php83-fpm \
    php83-opcache \
    php83-ctype \
    php83-dev \
    php83-curl \
    php83-fileinfo \
    php83-gd \
    php83-iconv \
    php83-mbstring \
    php83-mysqli \
    php83-pdo_mysql \
    php83-pear \
    php83-pcntl \
    php83-posix \
    php83-sockets \
    php83-xml \
    php83-xmlwriter \
    php83-zip \
    php83-ldap \
    php83-pecl-apcu \
    php83-bcmath \
    php83-tokenizer \
    php83-simplexml \
    php83-dom \
    dcron \
    imagemagick \
    openldap-clients \
    mariadb-client \
    nginx \
    py3-pygments \
    supervisor \
    nodejs \
    npm \
  && ln -sf /usr/bin/php83 /usr/bin/php

# Tailscale
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /usr/local/bin/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /usr/local/bin/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

# Cloudflared
COPY --from=docker.io/cloudflare/cloudflared:latest /usr/local/bin/cloudflared /usr/local/bin/cloudflared

RUN sed -i "s/;opcache.validate_timestamps=1/opcache.validate_timestamps=0/g" /etc/php83/php.ini \
  && sed -i "s/post_max_size = 8M/post_max_size = 64M/g" /etc/php83/php.ini

RUN addgroup -g 2000 wwwgrp-phorge \
  # User PHORGE (uid 2000, primary gid 2000)
  && adduser -u 2000 -G wwwgrp-phorge -h /srv/phorge -s /bin/bash -D PHORGE \
  # Nginx user (created by apk, add to group)
  && addgroup nginx wwwgrp-phorge

# Setting up Phorge from source
WORKDIR /srv/phorge
# hadolint ignore=DL3016
RUN git clone https://github.com/phorgeit/arcanist.git ./arcanist \
  && git clone https://github.com/phorgeit/phorge.git ./phorge \
  && npm install -prefix /srv/phorge/phorge/support/aphlict/server ws \
  && git config --system --add safe.directory /srv/phorge/arcanist \
  && git config --system --add safe.directory /srv/phorge/phorge \
  && chown -R PHORGE:wwwgrp-phorge /srv/phorge \
  && mkdir -p /repos && chown -R PHORGE:wwwgrp-phorge /repos

COPY preflight /preflight
RUN /preflight/setup.sh

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/libexec/git-core
EXPOSE 80 443 22 2222
VOLUME [ "/files" ]
VOLUME [ "/repos" ]
VOLUME [ "/var/log/phorge" ]
VOLUME [ "/var/lib/tailscale" ]
CMD ["/app/init.sh"]
