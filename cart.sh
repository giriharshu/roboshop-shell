script_path=$(dirname $0)
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>Configuring NodeJS repos <<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>>>Install NodeJS <<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>>>>>Add User <<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>>Add a Directory <<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>> Unzip App Contents <<<<<<<<<<<\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip

echo -e "\e[36m>>>>>>>>>> Install NodeJS dependencies <<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>> Copy Cart Systemd file <<<<<<<<<<<\e[0m"
cp ${script_path}/cart.service /etc/systemd/system/cart.service

systemctl daemon-reload

systemctl enable cart
systemctl start cart