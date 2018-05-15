#!/bin/bash
export GIT_SOURCE=${GIT_SOURCE}
export BRANCH_NAME=${BRANCH_NAME}
export NGINX_ROOT=${NGINX_ROOT:-"/opt/nginx/html"}
export NGINX_ROOT_INC=${NGINX_ROOT}/inc
export INC_TARGET=/opt/inc_target
mkdir -p ${INC_TARGET}

ps -ef | grep crond | grep -v grep
if [ $? -ne 0 ]
then
    echo "start crond....."
    crond
else
    echo "crond runing....."
fi


echo "NGINX_CONF is ${NGINX_CONF}" >> /opt/out.txt

nohup nginx &

tail -f -n 2000 /opt/out.txt
