script=$(realpath "$0")

echo ${script}

script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

dirname $0

echo -e "\e[36m>>>>>>>>>>Install Maven <<<<<<<<<<<\e[0m"
yum install maven -y

echo -e "\e[36m>>>>>>>>>>Add USer <<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>>Create Application Directory <<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>> Unzip App Contents <<<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip

echo -e "\e[36m>>>>>>>>>> Install Maven dependencies <<<<<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>>>>>> Copy Shipping Systemd file <<<<<<<<<<<\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m>>>>>>>>>> Start Shipping Services <<<<<<<<<<<\e[0m"
systemctl daemon-reload

systemctl enable shipping
systemctl start shipping

echo -e "\e[36m>>>>>>>>>> Install Mysql <<<<<<<<<<<\e[0m"
yum install mysql -y

echo -e "\e[36m>>>>>>>>>> Load the Schema <<<<<<<<<<<\e[0m"
mysql -h mysql-dev.gdevops89.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql

systemctl restart shipping