# docker-zhongkui-waf
docker for zhongkui-waf

项目地址：https://github.com/bukaleyang/zhongkui-waf.git

## docker部署

### 1、拉取docker-compose

```bash
git clone https://github.com/dossec/docker-zhongkui-waf
cd docker-zhongkui-waf
```

### 2、拉取github代码

```bash
git clone https://github.com/bukaleyang/zhongkui-waf.git
```

### 3、拉取docker镜像

```bash
docker pull dosoc/zhongkui-waf-alpine:20240820
```

### 4、运行dokcer

docker-compose运行

```bash
docker-compose up -d
docker-compose ps
```

如果配置了`GEOIP_LICENSE_KEY`和 `GEOIP_ACCOUNT_ID`，执行以下命令更新IP数据库

```bash
docker exec zhongkui-waf geoipupdate
```

### 5、其他

#### 使用mysql8

创建`init.sql` 的文件

```bash
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '6CsIaDsfRike';
```

docker-compose.yml

```yaml
version: "3"
services:
    zhongkui-waf:
        image: dosoc/zhongkui-waf-alpine:20240820
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

参数说明

- GEOIP_LICENSE_KEY=you key ：请修改为你的GEOIP KEY
- GEOIP_ACCOUNT_ID=you id：请修改为你的GEOIP ID
- MYSQL_ROOT_PASSWORD：MySQL root密码
- ./GeoIP：本地IP数据库目录

#### 使用mysql5.7

```bash
version: "3"
services:
    zhongkui-waf:
        image: dosoc/zhongkui-waf-alpine:20240820
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
docker-compose -f docker-compose-mysql5.7.yml up -d
docker-compose -f docker-compose-mysql5.7.yml ps
```

