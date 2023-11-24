nginx.rotate:
	sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.old
	sudo systemctl reload nginx

nginx.log:
	sudo tail -f /var/log/nginx/access.log

nginx.alp:
	alp json \
		--sort sum -r \
		-m "/posts/[0-9]+,/@\w+,/image/[0-9]+.(jpg|gif|png)" \
		-o count,method,uri,min,avg,max,sum \
		< /var/log/nginx/access.log

mysql-slow.rotate:
	sudo mv /var/log/mysql/mysql-slow.log /var/log/mysql/mysql-slow.log.old && sudo mysqladmin flush-logs

mysql-slow.log:
	sudo tail -f /var/log/mysql/mysql-slow.log

mysql-slow.dump:
	sudo mysqldumpslow /var/log/mysql/mysql-slow.log
