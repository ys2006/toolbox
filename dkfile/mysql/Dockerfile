FROM dylanyin/mycentos7.2:ver1.0

MAINTAINER dylan
USER root
# Install MySQL pre-requisites
RUN \
yum -y install perl pwgen libpwqu libpwquality && \
yum clean all && \
rm -fr /var/cache/*

# Add "mysql" user and "mysql" group first, to make sure their IDs get assigned consistently
RUN \
groupadd -r mysql && \
useradd -r -g mysql mysql && \
mkdir /docker-entrypoint-initdb.d

# Install and configure MySQL 5.6
# 1. Install latest 5.x package http://dev.mysql.com/downloads/repo/yum/
# 2. Disable all MySQL repositories
# 3. Enable the repository for MySQL 5.6
RUN \
yum -y install https://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm && \
yum-config-manager --disable mysql5* && \
yum-config-manager --enable mysql56-community && \
yum -y install mysql-community-server && \
yum clean all && \
rm -rf /var/cache/*

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod -v +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]

EXPOSE 3306

