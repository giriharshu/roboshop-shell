if [ -z "$mysql_root_password" ]
then
  echo input mysql root password missing
  exit
fi

yum module disable mysql -y

cp mysql.repo /etc/yum.repos.d/mysql.repo

yum install mysql-community-server -y

systemctl enable mysqld
systemctl start mysqld

mysql_secure_installation --set-root-pass ${mysql_root_password}

#mysql -uroot -pRoboShop@1