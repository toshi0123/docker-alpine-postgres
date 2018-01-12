# docker-alpine-postgres

This dockerfile installs only the postgres package.  
Not compiling any sources which exist in apline linux repos.  

And addtional packages of pgroonga.

Environment variables
---

| variables | example values | description |
| --------- | ------ | ----------- |
| POSTGRES_USER  | `hackmd` | DB username(default: `postgres`) |
| POSTGRES_PASSWORD | `hackmdpass` | DB user's password(default: `postgres`) Cannot set empty password. |
| POSTGRES_DB | `hackmd` | DB name(default: `postgres`) |
| LISTEN_ADDRESSES | `0.0.0.0/0` | listen addresses(default: `0.0.0.0/0`) |
| DB_EXTENSION | `pg_trgm` | DB extension(default: ) |
