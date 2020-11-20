#!/bin/bash

for i in `docker container ls | grep server | awk '{print $1}' | tac`
do
docker logs $i | grep "password :";
done

exit 0
