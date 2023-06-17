script_path=$(dirname $0)
source ${script_path}/common.sh

echo ${script_path}

echo -e "\e[36m>>>>>>>>>> Install Python <<<<<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[36m>>>>>>>>>> Add User <<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>> Create Application Directory <<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>> Unzip App Contents <<<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip

echo -e "\e[36m>>>>>>>>>> Install Python dependencies <<<<<<<<<<<\e[0m"
pip3.6 install -r requirements.txt

echo -e "\e[36m>>>>>>>>>> Copy Payment Systemd file <<<<<<<<<<<\e[0m"
cp ${script_path}/payment.service /etc/systemd/system/payment.service

echo -e "\e[36m>>>>>>>>>> Start Catalogue Services <<<<<<<<<<<\e[0m"
systemctl daemon-reload

systemctl enable payment
systemctl start payment