FROM alpine:3.6

RUN apk upgrade --no-cache && apk add --no-cache postgresql postgresql-contrib su-exec

ENV LANG en_US.utf8

ENV PGDATA /var/lib/postgresql/data
VOLUME /var/lib/postgresql/data

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
