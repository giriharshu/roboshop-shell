script_path=$(dirname $0)
source ${script_path}/common.sh

dirname $0

echo -e "\e[36m>>>>>>>>>> Install Golang <<<<<<<<<<<\e[0m"
yum install golang -y

echo -e "\e[36m>>>>>>>>>> IAdd User <<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>> Create Application Directory <<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>> Unzip App Contents <<<<<<<<<<<\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app
unzip /tmp/dispatch.zip

echo -e "\e[36m>>>>>>>>>> Install Golang dependencies <<<<<<<<<<<\e[0m"
go mod init dispatch
go get
go build

echo -e "\e[36m>>>>>>>>>> Copy Dispatch Systemd file <<<<<<<<<<<\e[0m"
cp ${script_path}/dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[36m>>>>>>>>>> Start Dispatch Services <<<<<<<<<<<\e[0m"
systemctl daemon-reload

systemctl enable dispatch
systemctl start dispatch