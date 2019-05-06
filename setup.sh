#!/bin/bash
set -eox pipefail

# Setup
rm -Rf initial_client
git init initial_client

cp crlf initial_client/
cp lf initial_client/

cd initial_client
git add *lf
git commit -a -m "Add files"
cd ..

# Server
rm -Rf server
git init --bare server

cd initial_client
git push --set-upstream ../server/ master
cd ..

cd server
git log
cd ..

# Windows clone
rm -Rf Windows
git init Windows
cd Windows
git config core.autocrlf true

git pull ../server
file crlf
file lf

cd ..

# Linux clone
rm -Rf Linux
git init Linux
cd Linux
git config core.autocrl input

git pull ../server
file crlf
file lf