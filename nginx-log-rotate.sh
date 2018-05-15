#!/bin/sh
##Create date: 2017-02-15
#Author: Chuck
#Action: logrotate nginx log  everyday
DATE_FORMAT=$(date +%Y%m%d)
BASE_DIR="/opt/nginx"
NGINX_LOG_DIR="${BASE_DIR}/logs"
LOGNAME="access"
[ -d ${NGINX_LOG_DIR} ] && cd ${NGINX_LOG_DIR} || exit 1
[ -f ${LOGNAME}.log ] || exit 1
/bin/mv ${LOGNAME}.log ${LOGNAME}_${DATE_FORMAT}.log
nginx -s reload -c ${NGINX_CONF}
find $NGINX_LOG_DIR -type f -name access.* -mtime +90| xargs rm -f