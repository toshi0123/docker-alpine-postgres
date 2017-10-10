#!/bin/sh
mkdir -p $PGDATA
chown -R postgres $PGDATA
chmod 700 $PGDATA

if [ -z "$(ls -A "$PGDATA")" ];then
	su-exec postgres initdb

	sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" $PGDATA/postgresql.conf

	: ${POSTGRES_USER:="postgres"}
	: ${POSTGRES_PASS:="postgres"}
	: ${POSTGRES_DB:="postgres"}
	: ${LISTEN_ADDRESSES:="0.0.0.0/0"}

	if [ "$POSTGRES_DB" != 'postgres' ]; then
		echo "CREATE DATABASE $POSTGRES_DB;" | su-exec postgres postgres --single -jE
	fi

	if [ "$POSTGRES_USER" != 'postgres' ]; then
		echo "CREATE USER $POSTGRES_USER WITH SUPERUSER PASSWORD '$POSTGRES_PASS';" | su-exec postgres postgres --single -jE
	else
		echo "ALTER USER $POSTGRES_USER WITH SUPERUSER PASSWORD '$POSTGRES_PASS';" | su-exec postgres postgres --single -jE
	fi

	{ echo; echo "host all all $LISTEN_ADDRESSES md5"; } >> $PGDATA/pg_hba.conf
fi

mkdir -p /run/postgresql
chown -R postgres /run/postgresql

exec su-exec postgres "$@"
