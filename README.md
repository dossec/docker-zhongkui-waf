# docker-zhongkui-waf
docker for zhongkui-waf

## docker部署

拉取github代码

```bash
git clone https://github.com/bukaleyang/zhongkui-waf.git
```

拉取docker镜像

```bash
docker pull dosoc/zhongkui-waf-alpine:20240819
```

### docker-compose-mysql5.7

```bash
version: "3"
services:
    zhongkui-waf:
        image: dosoc/zhongkui-waf-alpine:20240819
        container_name: zhongkui-waf
        restart: unless-stopped
        ports:
            - 1226:1226
            - 80:80
            - 443:443
        environment:
            #- GEOIP_LICENSE_KEY=you key
            #- GEOIP_ACCOUNT_ID=you id
            - MYSQL_HOST=zhongkui-mysql
            - MYSQL_USER=root
            - MYSQL_PASSWORD=6CsIaDsfRike
        volumes:
            - ./zhongkui-waf:/usr/local/openresty/zhongkui-waf
            - ./GeoIP:/usr/local/share/GeoIP
        networks:
            - zkwaf-net
        depends_on:
            - zhongkui-mysql
        
    zhongkui-mysql:
        image: mysql:5.7.44
        # image: mysql:8.0.37
        container_name: zhongkui-mysql
        restart: unless-stopped
        ports:
            - 3306:3306
        environment:
            MYSQL_DATABASE: zhongkui_waf
            MYSQL_ROOT_PASSWORD: 6CsIaDsfRike
        volumes:
            - ./mysql:/var/lib/mysql
            - ./log:/var/log/mysql
            - /etc/timezone:/etc/timezone:ro
            - /etc/localtime:/etc/localtime:ro
        networks:
            - zkwaf-net
networks:
  zkwaf-net:
    driver: bridge
```

运行

```bash
docker-compose up -d
```

### docker-compose-mysql8

使用MySQL8，创建`init.sql` 的文件

```bash
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '6CsIaDsfRike';
```

docker-compose.yml

```yaml
version: "3"
services:
    zhongkui-waf:
        image: dosoc/zhongkui-waf-alpine:20240819
        container_name: zhongkui-waf
        restart: unless-stopped
        environment:
            #- GEOIP_LICENSE_KEY=you key
            #- GEOIP_ACCOUNT_ID=you id
            - MYSQL_HOST=zhongkui-mysql
            - MYSQL_USER=root
            - MYSQL_PASSWORD=6CsIaDsfRike
        volumes:
            - ./zhongkui-waf:/usr/local/openresty/zhongkui-waf
            - ./GeoIP:/usr/local/share/GeoIP
        network_mode: host
        depends_on:
            - zhongkui-mysql
        
    zhongkui-mysql:
        # image: mysql:5.7.44
        image: mysql:8.0.37
        container_name: zhongkui-mysql
        restart: unless-stopped
        environment:
            MYSQL_DATABASE: zhongkui_waf
            MYSQL_ROOT_PASSWORD: 6CsIaDsfRike
        volumes:
            - ./mysql:/var/lib/mysql
            - ./log:/var/log/mysql
            - ./init.sql:/docker-entrypoint-initdb.d/init.sql
            - /etc/timezone:/etc/timezone:ro
            - /etc/localtime:/etc/localtime:ro
        #network_mode: host
        ports:
            - 3306:3306
```



