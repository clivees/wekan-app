#!/bin/bash
DATE=$(date +%Y-%m-%d-%H-%M)
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPTPATH
mkdir -p backups/$DATE
docker ps -a | grep 'wekan-db' &> /dev/null
if [ $? = 0 ]; then
docker exec -t wekan-db bash -c "rm -rf /dump/* ; mongodump -o /dump/"
docker cp wekan-db:/dump $SCRIPTPATH/backups/$DATE
tar -zcvf backups/$DATE.tgz -C $SCRIPTPATH/backups/$DATE .
if [ -f backups/$DATE.tgz ]; then
rm -fr backups/$DATE
find $SCRIPTPATH/backups/ -type f -mtime +7 -exec rm -f {} \;
fi 
else
echo "wekan-db container is not running"
exit 1
fi
