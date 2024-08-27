# docker-zhongkui-waf
docker for zhongkui-waf

项目地址：https://github.com/bukaleyang/zhongkui-waf.git

## docker部署

### 1、拉取docker-zhongkui-waf

```bash
git clone https://github.com/dossec/docker-zhongkui-waf
```

### 2、拉取zhongkui-waf代码

```bash
cd docker-zhongkui-waf
git clone https://github.com/bukaleyang/zhongkui-waf.git
```

### 3、运行dokcer

docker-compose 运行

```bash
docker-compose up -d
docker-compose ps
```

如果配置了`GEOIP_LICENSE_KEY`和 `GEOIP_ACCOUNT_ID`，执行以下命令更新IP数据库

```bash
docker exec zhongkui-waf geoipupdate
```

### 5、修改MySQL密码

有2处要同步修改：

- 修改`init.sql` 的文件MySQL密码

  ```bash
  ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '6CsIaDsfRike';
  ```

- `docker-compose.yml` MySQL密码

  ```bash
  MYSQL_ROOT_PASSWORD: 6CsIaDsfRike
  ```

