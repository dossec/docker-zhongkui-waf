#!/bin/bash

if [ -n "${MYSQL_HOST}" ] && [ -n "${MYSQL_USER}" ] && [ -n "${MYSQL_PASSWORD}" ]; then
    
    # 尝试 ping MySQL 主机
    ping_result=$(ping -c 1 "${MYSQL_HOST}" 2>&1)

    # 检查 ping 命令的返回值
    if [[ $? -ne 0 ]]; then
        MYSQL_IP=127.0.0.1
    else
        # 提取 IP 地址
        MYSQL_IP=$(echo "$ping_result" | grep PING | awk -F'[()]' '{print $2}')
    fi

    # MYSQL_IP=$(ping -c 1 ${MYSQL_HOST} | grep PING | awk -F'[()]' '{print $2}')

    sed -i '/"mysql": {/,/}/s/"state": "off"/"state": "on"/' /usr/local/openresty/zhongkui-waf/conf/system.json
    sed -i "/\"mysql\": {/,/},/s/\"host\": \"[^\"]*\"/\"host\": \"${MYSQL_IP}\"/" /usr/local/openresty/zhongkui-waf/conf/system.json
    sed -i "/\"mysql\": {/,/},/s/\"user\": \"[^\"]*\"/\"user\": \"${MYSQL_USER}\"/" /usr/local/openresty/zhongkui-waf/conf/system.json
    sed -i "/\"mysql\": {/,/},/s/\"password\": \"[^\"]*\"/\"password\": \"${MYSQL_PASSWORD}\"/" /usr/local/openresty/zhongkui-waf/conf/system.json
fi

chown -R nginx:nginx /usr/local/openresty/zhongkui-waf
# /usr/bin/openresty -g "daemon off;" -c /usr/local/openresty/nginx/conf/nginx.conf

if [ -n "$GEOIP_ACCOUNT_ID" ] && [ -n "$GEOIP_LICENSE_KEY" ]; then
    # 替换配置文件中的环境变量
    sed -i "s|youid|${GEOIP_ACCOUNT_ID}|g" /usr/local/etc/GeoIP.conf
    sed -i "s|youkey|${GEOIP_LICENSE_KEY}|g" /usr/local/etc/GeoIP.conf
    # geoipupdate -f /usr/local/etc/GeoIP.conf
fi

exec "$@"