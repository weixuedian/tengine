#!/usr/bin/env bash
docker rm -f tengine-test

docker build -t "registry.cn-beijing.aliyuncs.com/tigers/tengine:v2.2.0" .
docker push  "registry.cn-beijing.aliyuncs.com/tigers/tengine:v2.2.0"

#
##!/usr/bin/env bash
#echo "deploy_test start"
#CONTAINER_NAME=test.caidao.hexun.com
#array=("10.4.22.100")
#
#for data in ${array[@]}
#do
#    DOCKER_CMD="docker --host=${data}:2375 "
#    echo "REMOVING ${data}"
#    ${DOCKER_CMD} ps -a|grep ${CONTAINER_NAME} |grep -v grep
#	if [ $? -ne 0 ]
#	then
#		echo "start process....."
#		${DOCKER_CMD} run -d \
#			--env NGINX_ROOT=/opt/git_source/test.caidao.hexun.com \
#			--env NGINX_CONF=/opt/git_source/nginx/test.caidao.hexun.com/nginx.conf \
#			--volume /opt/git_source:/opt/git_source \
#			--volume /opt/inc/gbk:/opt/inc_source \
#			--volume /opt/docker/${CONTAINER_NAME}/log:/opt/nginx/logs \
#			--restart always \
#			--env BRANCH_NAME=master \
#			--env GIT_SOURCE=https://yuanyue%40staff.hexun.com:7c4fh8%40hexun@zqcode.idc.hexun.com/cdsq/cdsq-web.git \
#			--name ${CONTAINER_NAME} -p 9603:80 docker-registry.hexun.com/hexunzq/tengine:v2.3.0
#	fi
#
#	${DOCKER_CMD} exec -i ${CONTAINER_NAME} /opt/gitclone.sh
#done