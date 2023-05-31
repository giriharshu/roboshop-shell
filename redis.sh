echo -e "\e[36m>>>>>>>>>> Install remirepo <<<<<<<<<<<\e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[36m>>>>>>>>>> Enable Redis 6.2<<<<<<<<<<<\e[0m"
yum module enable redis:remi-6.2 -y

echo -e "\e[36m>>>>>>>>>> Install Redis <<<<<<<<<<<\e[0m"
yum install redis -y

sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis.conf


systemctl enable redis
systemctl start redis