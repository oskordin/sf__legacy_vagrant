#!/bin/bash

# Get all required software packages
sudo apt-get update
sudo apt-get -qq install gcc stow make

# Download the 8.4.22 postgres source code and unpack the archive
cd ~
wget https://ftp.postgresql.org/pub/source/v8.4.22/postgresql-8.4.22.tar.gz
tar zxf postgresql-8.4.22.tar.gz
cd postgresql-8.4.22

# Run the configuration script, build souces and install postgress to the folder in stow
./configure --without-zlib  --without-readline --prefix=/usr/local/stow/pgsql
make
sudo make install

# register the installed package
cd /usr/local/stow
sudo stow pgsql

# Create new user to handle PostgreSQL service
useradd -m postgres

# Create data folder for DB
mkdir -p /usr/local/pgsql/data
sudo chown postgres /usr/local/pgsql/data/

# Initialize DB and run service
su - postgres -c 'initdb -D /usr/local/pgsql/data'
su - postgres -c 'pg_ctl -D /usr/local/pgsql/data -l ~/logfile start'

psql -V