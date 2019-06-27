#!/bin/sh

DOCKER_UID=$(stat -c '%u' /var/www/)
DOCKER_GID=$(stat -c '%g' /var/www/)

echo "Docker: uid = ${DOCKER_UID}, gid = ${DOCKER_GID}"

usermod -u ${DOCKER_UID} www-data 2> /dev/null && {
    groupmod -g ${DOCKER_GID} www-data 2> /dev/null || usermod -a -G ${DOCKER_GID} www-data
}

# make sure ssh private key is added to ssh-agent
eval `ssh-agent -s`
ssh-add /root/.ssh/git

chmod -R 777 /tmp

exec supervisord -n
