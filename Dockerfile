FROM cgr.dev/chainguard/wolfi-base:latest@sha256:9c86299eaeb27bfec41728fc56a19fa00656c001c0f01228b203379e5ac3ef28

ENV \
    LUA_CPATH=/usr/lib/lua/5.1/?.so;/usr/lib/lua/?/?.so;/usr/lib/lua/?.so;/usr/lib/lua/?.lua; \
    LUA_PATH=/usr/share/lua/5.1/?.lua;/usr/lib/lua/?.lua;/usr/lib/lua/?.lua;/usr/share/lua/?.lua \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/luajit/bin \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

WORKDIR /etc/nginx


RUN apk add --upgrade --update --no-cache \
        ingress-nginx-controller-1.12 \
        ingress-nginx-controller-compat-1.12 \
        ingress-nginx-opentelemetry-plugin-1.12 \
        heimdal-libs \
        icu-libs \
        icu-data-full \
        libfontconfig1 \
        msgpack-cxx && \
    addgroup -S -g 82 www-data && \
    adduser -S -D -H -u 101 -h /usr/local/nginx \
    -s /sbin/nologin -G www-data -g www-data www-data && \
    mkdir -p /tmp/nginx /etc/ingress-controller/auth /etc/ingress-controller/ssl /etc/ingress-controller/geoip /etc/ingress-controller/telemetry && \ 
    chown -R www-data:www-data /etc/ingress-controller/auth /etc/ingress-controller/ssl /etc/ingress-controller/geoip /etc/ingress-controller/telemetry /tmp/nginx /etc/nginx && \
    chmod -R 750 /etc/ingress-controller/auth /etc/ingress-controller/ssl /etc/ingress-controller/geoip /etc/ingress-controller/telemetry /tmp/nginx /etc/nginx && \
    apk del --no-cache --purge -r wolfi-keys busybox apk-tools

ENTRYPOINT [ "/nginx-ingress-controller" ]
CMD [ "/usr/bin/dumb-init", "--" ]
