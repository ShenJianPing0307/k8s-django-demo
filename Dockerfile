FROM python:3.7-alpine
LABEL maintainer="iveboy"
#ENV 设置环境变量
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN mkdir -p /opt/web
ADD . /opt/web/
WORKDIR /opt/web

# 拷贝nginx配置文件
COPY ./config/web_nginx.conf /etc/nginx/

RUN mkdir -p ~/.pip

RUN mv ./pip.conf ~/.pip

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN  set -x \
    && apk add --no-cache --virtual .build-deps build-base g++ gcc libxslt-dev python2-dev linux-headers \
    && apk add --no-cache pwgen git tzdata zlib-dev freetype-dev jpeg-dev  mariadb-dev postgresql-dev \
    && apk add --no-cache nginx \
    && python -m pip install --upgrade pip \
    && pip --no-cache-dir install -r requirements.txt \
    && pip --no-cache-dir install uwsgi \
    && chmod +x run.sh \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

EXPOSE 8002

CMD ["./run.sh"]