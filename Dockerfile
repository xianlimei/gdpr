FROM centos:7

LABEL maintainer="Li Cheng 348130346@qq.com"

COPY dpia /root/dpia
COPY privileges.sql /root/privileges.sql
COPY my.cnf /etc/my.cnf

RUN  yum -y update \
	&& yum -y install wget \
	&& yum -y install numactl \
	&& yum -y install gcc \
	&& yum -y install make \
	&& yum -y install openssl-devel \
	&& yum -y install libaio-devel \
	&& yum -y install initscripts \
	&& yum -y  install vim \
	&& yum clean all

RUN cd /root \
	&& wget https://www.python.org/ftp/python/3.5.4/Python-3.5.4.tgz \
	&& wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz

RUN cd /root \
 	&& tar xvzf Python-3.5.4.tgz \
	&& cd Python-3.5.4 \ 
	&& ./configure --prefix=/usr/python3 --enable-optimizations \
	&& make \
	&& make install \
	&& ln -s /usr/python3/bin/python3 /usr/bin/python3 \
	&& ln -s /usr/python3/bin/pip3.5 /usr/bin/pip3.5 \
	&& pip3.5 install --upgrade pip \
	&& pip3.5 install django \
	&& pip3.5 install pymysql \
	&& sed -i -e '35,36d'  /usr/python3/lib/python3.5/site-packages/django/db/backends/mysql/base.py \
	&& sed -i -e '146s/decode/encode/'  /usr/python3/lib/python3.5/site-packages/django/db/backends/mysql/operations.py

RUN cd /root \
    && tar -xvf mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz \
	&& mv mysql-5.7.22-linux-glibc2.12-x86_64 /usr/local/mysql \
	&& cd /usr/local/mysql/ \
	&& groupadd mysql \
	&& useradd mysql -g mysql \
	&& mkdir -p /usr/local/mysql/data \
	&& chown -R mysql.mysql /usr/local/mysql/ \
	&& /usr/local/mysql/bin/mysqld --user=mysql --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data --initialize \
	&& cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql \
	&& chkconfig mysql on \
	&& service mysql start 

RUN echo "import pymysql" >> /usr/python3/lib/python3.5/site-packages/django/db/backends/mysql/__init__.py
RUN echo "pymysql.install_as_MySQLdb()" >> /usr/python3/lib/python3.5/site-packages/django/db/backends/mysql/__init__.py

#&& /usr/local/mysql/bin/mysql -u root -p dpai< /root/dpia/dpia.sql \
#&& /usr/local/mysql/bin/mysql -u root -p mysql< /root/privileges.sql\
#&& service mysql restart

#docker build -t dpia .	 
#vim /etc/docker/daemon.json
#{
#"registry-mirrors":["https://docker.mirrors.ustc.edu.cn"]
#}
#systemctl daemon-reload
#systemctl restart docker
#docker build -t dpia .	
#docker run -p 8000:8000 --name dpia dpia

CMD ["python3", "/root/dpia/manage.py", "runserver" ,"0.0.0.0:8000"]