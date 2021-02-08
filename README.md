# 介绍

A generic PHP enviroment on Docker

This Docker Compose development environment includes

* PHP 7.4
* MySQL8
* Nginx
* Composer latest

# 使用方法

## 准备开发环境

首先拷贝.env.dist为.env并设置`APP_DIR` 环境变量

APP_DIR变量为app源代码的路径，可为相对路径。假设有如下目录结构
```
www
  docker
  magento2
```
那么设置APP_DIR=../magento2

然后，启动容器
```bash
cd docker
docker-compose up
```
or 
```
make start
```

## Build image
```

```
# Troubleshooting

## 如何进入容器？

```bash
docker exec -it $(docker-compose ps -q php-docker_app_1) sh
```

## 如何获取nginx的ip地址？

```
docker inspect $(docker-compose ps -q nginx) | grep IPAddress
```

# Quick install Magento2

```
bin/magento setup:install --base-url=http://magento2-app/ \
--db-host=magento2-mysql --db-name=magento2 --db-user=root --db-password='' \
--admin-firstname=Magento --admin-lastname=User --admin-email=user@example.com \
--admin-user=admin --admin-password=admin123 --language=en_GB \
--currency=GBP --timezone=Europe/London --use-rewrites=1 \
--search-engine=elasticsearch7 --elasticsearch-host=magento2-es \
--elasticsearch-port=9200 --allow-parallel-generation
```