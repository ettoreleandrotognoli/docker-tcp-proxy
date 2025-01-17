FROM haproxy:lts-alpine

USER root
RUN apk add --no-cache python3 py3-pip &&\
     pip3 install --no-cache-dir dnspython

COPY magic-entrypoint.py /magic-entrypoint

ENV NAMESERVERS="208.67.222.222 8.8.8.8 208.67.220.220 8.8.4.4" \
    LISTEN=:100 \
    PRE_RESOLVE=0 \
    TALK=talk:100 \
    TIMEOUT_CLIENT=5s \
    TIMEOUT_CLIENT_FIN=5s \
    TIMEOUT_CONNECT=5s \
    TIMEOUT_SERVER=5s \
    TIMEOUT_SERVER_FIN=5s \
    TIMEOUT_TUNNEL=5s \
    UDP=0 \
    VERBOSE=0

# Metadata
ARG VCS_REF
ARG BUILD_DATE
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.vendor=Tecnativa \
      org.label-schema.license=Apache-2.0 \
      org.label-schema.build-date="$BUILD_DATE" \
      org.label-schema.vcs-ref="$VCS_REF" \
      org.label-schema.vcs-url="https://github.com/Tecnativa/docker-tcp-proxy"

CMD ["sh", "-c", "python3 magic-entrypoint; haproxy -f /usr/local/etc/haproxy/haproxy.cfg"]