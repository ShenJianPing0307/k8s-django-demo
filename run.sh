#!/bin/sh

uwsgi --ini /opt/web/config/uwsgi.ini && echo "uwsgi服务启动成功"
nginx -c /etc/nginx/web_nginx.conf -g 'daemon off;'
