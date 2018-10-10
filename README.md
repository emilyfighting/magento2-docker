# 介绍
This Docker Compose development environment includes

* PHP 7.1
* MariaDB
* Nginx
* Composer 1.6.5

# 使用方法

## 准备开发环境

首先拷贝.env.dist为.env并设置`PINTUSHI_DIR`，`SSH_PRIVATE_KEY_NAME` 环境变量

PINTUSHI_DIR变量为pintushi2源代码的路径，可为相对路径。假设有如下目录结构
```
www
  docker
  pintushi2
```
那么设置PINTUSHI_DIR=../pintushi2

SSH_PRIVATE_KEY_NAME为私钥文件名，比如你私钥路径为`~/.ssh/id_rsa`, 那么设置
```
SSH_PRIVATE_KEY_NAME=id_rsa
```
然后，启动容器
```bash
cd docker
docker-compose up
```
## 配置pintushi2项目数据库参数

注意是pintushi2项目，而不是本库中的.env文件
.env
```
DATABASE_URL="mysql://pintushi:pintushi@pintushi-mysql:3306/pintushi_dev"
```

现在，你可访问http://localhost:9000。

# Troubleshooting

## 如何进入容器？

```bash
docker exec -it $(docker-compose ps -q pintushi-app) bash
```

## 如何获取nginx的ip地址？

```
docker inspect $(docker-compose ps -q nginx) | grep IPAddress
```
