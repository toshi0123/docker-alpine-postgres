#!/bin/sh

apk add --no-cache --virtual .builddev build-base lz4-dev wget ca-certificates postgresql-dev binutils

# install groonga
wget https://packages.groonga.org/source/groonga/groonga-7.0.9.tar.gz
tar xvzf groonga-7.0.9.tar.gz
cd groonga-7.0.9
./configure --with-lz4
make -j$(nproc)
make install

cd -

# install pgroonga
wget https://packages.groonga.org/source/pgroonga/pgroonga-2.0.2.tar.gz
tar xvf pgroonga-2.0.2.tar.gz
cd pgroonga-2.0.2
make -j$(nproc)
make install

cd -

rm -rf groonga-7.0.9 pgroonga-2.0.2
rm -f  groonga-7.0.9.tar.gz pgroonga-2.0.2.tar.gz

# Remove build dependencies
apk del --no-cache .builddev
