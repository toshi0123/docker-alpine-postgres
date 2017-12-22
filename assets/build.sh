#!/bin/sh

apk add --no-cache --virtual .builddev build-base lz4-dev wget ca-certificates postgresql-dev

# install groonga
wget -q https://packages.groonga.org/source/groonga/groonga-7.0.9.tar.gz
tar xvzf groonga-7.0.9.tar.gz
cd groonga-7.0.9
./configure --with-lz4
make -j$(nproc)
make install

cd -

# install pgroonga
wget -q https://packages.groonga.org/source/pgroonga/pgroonga-2.0.2.tar.gz
tar xvf pgroonga-2.0.2.tar.gz
cd pgroonga-2.0.2
make -j$(nproc)
make install

cd -

rm -rf groonga-7.0.9 pgroonga-2.0.2
rm -f  groonga-7.0.9.tar.gz pgroonga-2.0.2.tar.gz

# Remove build dependencies
apk del --no-cache .builddev

# Install for runtime
RUNDEP=`scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/sbin | tr ',' '\n' | sort -u | awk 'system("[ -e /lib/" $1 " -o -e /usr/lib/" $1 " -o -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }'`

apk add --no-cache $RUNDEP
