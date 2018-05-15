#!/bin/bash
export GIT_SOURCE=${GIT_SOURCE}
export BRANCH_NAME=${BRANCH_NAME}
export NGINX_ROOT=${NGINX_ROOT:-"/opt/nginx/html"}
export NGINX_ROOT_INC=${NGINX_ROOT}/inc
export INC_TARGET=/opt/inc_target
mkdir -p ${INC_TARGET}

#ps -ef | grep crond | grep -v grep
#if [ $? -ne 0 ]
#then
#    echo "start crond....."
#    crond
#else
#    echo "crond runing....."
#fi
#
#
#echo "NGINX_CONF is ${NGINX_CONF}" >> /opt/out.txt
#
#nohup nginx &
#
#tail -f -n 2000 /opt/out.txt

#!/bin/sh

PATH=$PATH:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
# remove ./.git/index.lock
mkdir -p /opt/git_source && cd /opt/git_source && rm -f /opt/git_source/.git/index.lock
# define out file
OUT=/opt/out.txt
#the first param is git version
GIT_VERSION=$1
echo "GIT_VERSION=${GIT_VERSION}" | tee -a $OUT
# define nginx config file
NGINX_CONF=${NGINX_CONF:-"/opt/nginx/nginx.conf"}

NGINX_ROOT=${NGINX_ROOT:-"/opt/nginx/html"}

NGINX_ROOT_INC=${NGINX_ROOT:-"/opt/nginx/html"}/inc

INC_TARGET=/opt/inc_target
# whether nginx running
NGINX_RUNNING=0

ps -fe|grep nginx |grep -v grep
if [ $? -ne 0 ]
then
	NGINX_RUNNING=0
	echo "NGINX_RUNNING=0" | tee -a $OUT
else
	NGINX_RUNNING=1
	echo "NGINX_RUNNING=1" | tee -a $OUT
fi




if [ "GIT_SOURCE" != "" ]; then
	if [ ! -d .git ]; then
	    echo `date` "git not exists" | tee -a $OUT
	    git init | tee -a $OUT
	    git remote add origin GIT_SOURCE | tee -a $OUT
	    git fetch --all | tee -a $OUT
	    git branch BRANCH_NAME origin/BRANCH_NAME | tee -a $OUT
	    git reset --hard BRANCH_NAME | tee -a $OUT
	    git checkout BRANCH_NAME | tee -a $OUT
	    prev=$(git rev-list HEAD -n 1)
	    sed -i "s/____stamp_new/${prev:0:8}/g" ${NGINX_CONF}
	    # <<<<<<<<<<<link nginx config file start
	    if [ ! -f "/opt/nginx/nginx.conf" ]; then
		    ln -s ${NGINX_CONF} /opt/nginx/nginx.conf
		fi
		# link nginx config file end>>>>>>>>>>>>>
	    if [ "${NGINX_RUNNING}" == "0" ]; then
			nginx
		else
			nginx -s quit && nginx | tee -a $OUT
		fi
	else
	    echo "1) git exists" `date`| tee -a $OUT

	    echo "2) git fetch --all" | tee -a $OUT
	    git fetch --all | tee -a $OUT

	    echo "3) git reset --hard ${GIT_VERSION}" | tee -a $OUT
	    git reset --hard ${GIT_VERSION} | tee -a $OUT

	    echo "4) <<<<<<<<<<<<UPDATE NGINX CONFIG START<<<<<<<<<<" | tee -a $OUT
	    sed -i "s/____stamp_new/${GIT_VERSION:0:8}/g" ${NGINX_CONF}

	    echo "5) update nginx stamp complete"  | tee -a $OUT
	    if [ ! -f "/opt/nginx/nginx.conf" ]; then
		    ln -s ${NGINX_CONF} /opt/nginx/nginx.conf
		fi
	    if [ "${NGINX_RUNNING}" == "0" ]; then
			nginx
		else
			nginx -s reload | tee -a $OUT
		fi

	    echo "6) nginx killed and restart" | tee -a $OUT

	    echo "7) >>>>>>>>>>>>NGINX LOAD END>>>>>>>>>>>>>>>>>>>>>" | tee -a $OUT

	fi

fi

if [ ! -d "${NGINX_ROOT_INC}" ]
then
	echo "NOT EXISTS ${NGINX_ROOT_INC}" | tee -a $OUT
	if [ -d "${NGINX_ROOT}" ]
	then
		echo "EXISTS ${NGINX_ROOT}" | tee -a $OUT
		ln -s ${INC_TARGET} ${NGINX_ROOT_INC}
	fi
fi

if [ ! -d "/opt/nginx/html" ]
then
	echo "NOT EXISTS /opt/nginx/html" | tee -a $OUT
	if [ -d "${NGINX_ROOT}" ]
	then
		echo "EXISTS ${NGINX_ROOT}" | tee -a $OUT
		ln -s ${NGINX_ROOT} /opt/nginx/html
	fi
fi

echo "----------------------------------`date`" | tee -a $OUT
echo "----------------------------------------" | tee -a $OUT