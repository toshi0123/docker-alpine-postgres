FROM alpine:edge

COPY assets assets/

RUN apk upgrade --no-cache && apk add --no-cache postgresql postgresql-contrib su-exec && \
    /bin/sh -ex assets/build.sh

ENV LANG en_US.utf8

ENV PGDATA /var/lib/postgresql/data
VOLUME /var/lib/postgresql/data

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
