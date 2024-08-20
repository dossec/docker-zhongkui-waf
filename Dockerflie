FROM alpine:3.15
LABEL maintainer="https://github.com/dossec/docker-zhongkui-waf"

ENV TZ=Asia/Shanghai \
    OPENRESTY_PATH=/usr/local/openresty

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apk add --no-cache bash git curl zip perl make build-base libffi-dev openssl-dev gcc sudo vim python2 tzdata gnupg \
    && wget -q -O /etc/apk/keys/admin@openresty.com-5ea678a6.rsa.pub 'http://openresty.org/package/admin@openresty.com-5ea678a6.rsa.pub' \
    && . /etc/os-release \
    && MAJOR_VER=`echo $VERSION_ID | sed 's/\.[0-9]\+$//'` \
    && echo "http://openresty.org/package/alpine/v$MAJOR_VER/main" \
    | tee -a /etc/apk/repositories \
    && apk add --no-cache openresty
# apk add --no-cache libmaxminddb 

COPY src /tmp

WORKDIR /tmp

# zhongkui-waf 配置
COPY nginx.conf /usr/local/openresty/nginx/conf/
RUN unzip -q zhongkui-waf-master.zip \
    && mv zhongkui-waf-master ${OPENRESTY_PATH}/zhongkui-waf \
    && rm -rf /tmp/zhongkui-waf-master.zip \
    && echo "nginx ALL=NOPASSWD:  ${OPENRESTY_PATH}/nginx/sbin/nginx"  | tee /etc/sudoers.d/nginx \
    && addgroup -S nginx \
    && adduser -D -S -G nginx nginx \
    && mkdir -p ${OPENRESTY_PATH}/nginx/logs/hack \
    && chmod -R 755 ${OPENRESTY_PATH}/nginx/logs/hack \
    && chown -R nginx:nginx ${OPENRESTY_PATH}/nginx/logs \
    && chown -R nginx:nginx ${OPENRESTY_PATH}/zhongkui-waf \
    && tar xf libmaxminddb-1.7.1.tar.gz \
    && cd /tmp/libmaxminddb-1.7.1 \
    && ./configure && make && make install && echo /usr/local/lib >> /etc/ld.so.conf \
    && rm -rf /tmp/libmaxminddb-1.7.1* \
    && cd /tmp \
    && unzip -q libinjection-master.zip \
    && cd /tmp/libinjection-master \
    && make all && mv ./src/libinjection.so ${OPENRESTY_PATH}/lualib/libinjection.so \
    && rm -rf /tmp/libinjection-master* \
    && cd /tmp \
    && tar xf luaossl-rel-20220711.tar.gz \
    && cd /tmp/luaossl-rel-20220711 \
    && make all5.1 includedir=${OPENRESTY_PATH}/luajit/include/luajit-2.1 && make install5.1 \
    && rm -rf /tmp/luaossl-rel-20220711* \
    && cd /tmp \
    && unzip -q luafilesystem-master.zip \
    && cd ./luafilesystem-master \
    && cp -r ${OPENRESTY_PATH}/luajit/include/luajit-2.1/* /usr/local/include/ \
    && make INCS=/usr/local/openresty/luajit/include/luajit-2.1 \
    && mv ./src/lfs.so ${OPENRESTY_PATH}/lualib/lfs.so \
    && rm -rf luafilesystem-master* \
    && mkdir -p /usr/local/etc/ \
    && echo "AccountID youid" > /usr/local/etc/GeoIP.conf \
    && echo "LicenseKey youkey" >> /usr/local/etc/GeoIP.conf \
    && echo "EditionIDs GeoLite2-City" >> /usr/local/etc/GeoIP.conf \
    && echo "DatabaseDirectory /usr/local/share/GeoIP" >> /usr/local/etc/GeoIP.conf \
    && mkdir -p /usr/local/share/GeoIP \
    && cd /tmp/ \
    && tar xf geoipupdate_6.0.0_linux_386.tar.gz \
    && mv ./geoipupdate_6.0.0_linux_386/geoipupdate /usr/local/bin/geoipupdate \
    && chmod +x /usr/local/bin/geoipupdate \
    && rm -rf /tmp/geoipupdate_6.0.0_linux_386*

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

EXPOSE 1226 80 443

WORKDIR ${OPENRESTY_PATH}

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/openresty", "-g", "daemon off;", "-c", "/usr/local/openresty/nginx/conf/nginx.conf"]