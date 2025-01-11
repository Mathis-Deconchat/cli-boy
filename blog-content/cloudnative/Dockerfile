FROM ghcr.io/cloudnative-pg/postgresql:14.9-13 
USER root
RUN apt-get update && apt-get install -y curl
RUN apt-get install postgresql-14-wal2json
user postgres