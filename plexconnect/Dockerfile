FROM alpine:3.11

ARG PLEXCONNECT_TAG=V0.7.5

# Create 'app' user without a password to use instead of root.
RUN adduser -D app

RUN apk add --no-cache python2 py-pillow openssl sed
RUN mkdir -p /opt/plexconnect /config && chown app:app /opt/plexconnect /config

USER app
RUN wget -O /tmp/plexconnect.tar.gz https://github.com/iBaa/PlexConnect/archive/refs/tags/${PLEXCONNECT_TAG}.tar.gz \
    && tar -xvf /tmp/plexconnect.tar.gz -C /opt/plexconnect --strip-components 1 \
    && rm /tmp/plexconnect.tar.gz

# Doesn't seem to affect the stdout log level but disables writing logs to a file.
ENV PLEXCONNECT_LOGLEVEL Off

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 53 80 443

CMD ["python", "/opt/plexconnect/PlexConnect.py"]
