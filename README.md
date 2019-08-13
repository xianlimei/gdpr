# gdpr
《欧盟一般数据保护条例》（GDPR）带给企业的不仅是隐私政策的更新，而且是要求企业对整体数据治理文化和数据安全制度进行梳理和制定，其中数据保护影响评估（DPIA）制度被此次GDPR上升为特定情形下的强制性要求。本文结合猎豹dpia系统进行的一些修改，支持docker部署更加简单，后续会新增差分隐私保护、泛化等匿名保护技术。

使用：  
1、进入docker  
	docker exec -it dpia bash	  
2、启动mysql  
	service mysql restart  
3、创建数据库  
	CREATE DATABASE IF NOT EXISTS dpia  DEFAULT CHARSET utf8 COLLATE utf8_general_ci;  
	use dpia  
	source /root/dpia/dpia.sql  
	;use mysql; create user dpia identified by '123456';grant all on dpia.* to dpia@'%' identified by '123456' with grant option;flush privileges;  
7、重启数据库  
	service mysql restart  
8、启动dpiaweb服务  
	/usr/bin/python3 /root/dpia/manage.py runserver 0.0.0.0:8000  
9、访问http://xxx:8000/index/  
