FROM centos:7
MAINTAINER weixuedain 112606652@qq.com

ENV NGINX_VERSION tengine-2.2.0
# install dependency
RUN yum -y update && yum -y install wget tar openssl openssl-devel git gcc gcc-c++ autoconf automake make \
libxml2 libxml2-dev libxslt-devel gd-devel perl-devel perl-ExtUtils-Embed GeoIP GeoIP-devel GeoIP-data inotify-tools vixie-cron crontabs logrotate


# download tengine 2.2.0
RUN  wget http://tengine.taobao.org/download/${NGINX_VERSION}.tar.gz && \
 tar -zvxf ${NGINX_VERSION}.tar.gz && \
 rm -rf ${NGINX_VERSION}.tar.gz && \
 mv ${NGINX_VERSION} /opt/${NGINX_VERSION}
# download ngx_http_substitutions_filter_module
RUN cd /opt/${NGINX_VERSION} && git clone git://github.com/yaoweibin/ngx_http_substitutions_filter_module.git

RUN cd /opt/${NGINX_VERSION} && ./configure --enable-mods-static=all \
        --user=root \
        --group=root \
        --prefix=/opt/nginx \
        --conf-path=/opt/nginx/nginx.conf \
        --lock-path=/opt/nginx/nginx.lock \
        --pid-path=/opt/nginx/nginx.pid \
        --http-client-body-temp-path=/opt/nginx/body \
        --http-fastcgi-temp-path=/opt/nginx/fastcgi \
        --http-proxy-temp-path=/opt/nginx/proxy \
        --http-scgi-temp-path=/opt/nginx/scgi \
        --http-uwsgi-temp-path=/opt/nginx/uwsgi \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --with-http_gunzip_module \
        --with-md5=/usr/include/openssl \
        --with-sha1-asm \
        --with-md5-asm \
        --with-http_auth_request_module \
        --with-http_image_filter_module \
        --with-http_addition_module \
        --with-http_dav_module \
        --with-http_realip_module \
        #--with-http_spdy_module \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_xslt_module \
        --with-http_upstream_ip_hash_module=shared \
        --with-http_upstream_least_conn_module=shared \
        --with-http_upstream_session_sticky_module=shared \
        --with-http_map_module=shared \
        --with-http_user_agent_module=shared \
        --with-http_mp4_module \
        --with-http_split_clients_module=shared \
        --with-http_access_module=shared \
        --with-http_user_agent_module=shared \
        --with-http_degradation_module \
        --with-http_upstream_check_module \
        --with-http_upstream_consistent_hash_module \
        --with-ipv6 \
        --with-file-aio \
        --with-mail \
        --with-mail_ssl_module \
        --with-pcre \
        --with-pcre-jit \
        --with-debug \
        --http-log-path=/opt/nginx/logs/access.log \
        --error-log-path=/opt/nginx/logs/error.log \
        --sbin-path=/usr/sbin/nginx \
        --add-module=ngx_http_substitutions_filter_module

RUN cd /opt/${NGINX_VERSION} && make && make install
# set permission
RUN chown -R root:root /opt/nginx \
	&& chmod -R a+rw /opt/nginx \
	&& rm -rf /opt/${NGINX_VERSION} \
	&& rm -rf /opt/nginx/nginx.conf \
	&& rm -rf /opt/nginx/html \
	&& mkdir -p /opt/inc_target
	
# cp resource
COPY mime.types /opt/nginx/
COPY entry.sh /opt/
COPY /conf/inotify-tools-3.14-8.el7.x86_64.rpm /opt/
COPY nginx-log-rotate.sh /opt/
COPY out.txt /opt/


# install inotify
RUN rpm -ivh /opt/inotify-tools-3.14-8.el7.x86_64.rpm
# set executable
RUN chmod +x /opt/*.sh
# log rotate
RUN echo '0 0 */1 * * /opt/nginx-log-rotate.sh' >> /var/spool/cron/root


WORKDIR /opt

EXPOSE 80 443

VOLUME /opt/inc_source

CMD ["/opt/entry.sh"]


