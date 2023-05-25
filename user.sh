curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y

useradd roboshop

mkdir /app

curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip

npm install

cp user.servie /etc/systemd/system/user.service

systemctl daemon-reload

systemctl enable user
systemctl start user

cp mango.repo /etc/yum.repos.d/mongo.repo

yum install mongodb-org-shell -y

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js

