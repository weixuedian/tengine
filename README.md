创建docker镜像
docker build -t "tengine:v2.1.0" .
.代表当前目录

 
运行docker
docker run --name=tengine -d -p 9002:80 -v /opt/docker/tengine/html/inc:/etc/nginx/html/inc  tengine:v2.1.0 
-p端口，前面是宿主机端口，后面的是docker端口，-d后台运行


inotify : 监控文件变更
cron : 定时任务
nginx-log-rotate : nginx 日志 rotate

