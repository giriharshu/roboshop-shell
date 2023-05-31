echo -e "\e[36m>>>>>>>>>>Configuring NodeJS repos <<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>>> Install NodeJS <<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>>>>> Add Application USer <<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>> Create Application Directory <<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>> Unzip App Contents <<<<<<<<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip

echo -e "\e[36m>>>>>>>>>> Install NodeJS dependencies <<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>> Install NodeJS dependencies <<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service

echo -e "\e[36m>>>>>>>>>> Start User Services <<<<<<<<<<<\e[0m"
systemctl daemon-reload

systemctl enable user
systemctl start user

echo -e "\e[36m>>>>>>>>>> Copy Mangodb repo <<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/mango.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>> Install Mangodb Client <<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

mongo --host mangodb-dev.gdevops89.online </app/schema/user.js

