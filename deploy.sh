#!/bin/bash -eux

# 設定ファイルのコピー
#git pull origin
if [ $# -ne 1 ]; then
  echo "引数にブランチ名を指定してください"
  exit 1
fi

git fetch origin
git checkout origin/$1
echo "checkout $1"

sudo cp -r etc/nginx/ /etc/
sudo cp -r etc/mysql/ /etc/
echo "copy config files"

# アプリ・ミドルウェアの再起動
sudo systemctl restart nginx
sudo systemctl restart mysql
sudo systemctl restart isuconquest.ruby
echo "restart nginx, mysql, isuports"

# slow query logを有効化する
QUERY="
set global slow_query_log_file = '/var/log/mysql/mysql-slow.log';
set global long_query_time = 0;
set global slow_query_log = ON;
"
echo $QUERY | sudo mysql -uroot -proot
echo "enable slow query log"

# log permission
sudo chmod 777 /var/log/nginx /var/log/nginx/*
sudo chmod 777 /var/log/mysql /var/log/mysql/*
echo "change log permission"
