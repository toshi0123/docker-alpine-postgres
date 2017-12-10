#!/bin/sh
mkdir -p $PGDATA
chown -R postgres $PGDATA

if [ -z "$(ls -A "$PGDATA")" ];then
	su-exec postgres initdb

	sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" $PGDATA/postgresql.conf

	: ${POSTGRES_USER:="postgres"}
	: ${POSTGRES_PASSWORD:="postgres"}
	: ${POSTGRES_DB:="postgres"}
	: ${LISTEN_ADDRESSES:="0.0.0.0/0"}

	if [ "$POSTGRES_DB" != 'postgres' ]; then
		echo "CREATE DATABASE $POSTGRES_DB;" | su-exec postgres postgres --single -jE
	fi

	if [ "$POSTGRES_USER" != 'postgres' ]; then
		echo "CREATE USER $POSTGRES_USER WITH SUPERUSER PASSWORD '$POSTGRES_PASSWORD';" | su-exec postgres postgres --single -jE
	else
		echo "ALTER USER $POSTGRES_USER WITH SUPERUSER PASSWORD '$POSTGRES_PASSWORD';" | su-exec postgres postgres --single -jE
	fi
	
	if [ "$DB_EXTENSION" == "pg_trgm" ]; then
		echo "CREATE EXTENSION IF NOT EXISTS pg_trgm;" | su-exec postgres postgres --single -jE $POSTGRES_DB
	fi

	{ echo; echo "host all all $LISTEN_ADDRESSES md5"; } >> $PGDATA/pg_hba.conf
fi

chmod 700 $PGDATA

mkdir -p /run/postgresql
chown -R postgres /run/postgresql

exec su-exec postgres "$@"
