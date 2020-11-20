#!/bin/bash

read -p "username: " username
read -p "host: " host
echo "fake connecting..."
echo "connection - OK"
echo "retrieving link..."
echo; echo; echo;
echo "login link: ${username}:s0mePa55W0RD@${host}"
echo "save your login link in safe place!"
exit 0