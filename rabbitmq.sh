rabbitmq_appuser_password=$1

echo -e "\e[36m>>>>>>>>>>Configure YUM Repos from the script provided by vendor <<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>>>Configure YUM Repos for RabbitMQ <<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>>>Install RabbitMQ <<<<<<<<<<<\e[0m"
yum install rabbitmq-server -y

echo -e "\e[36m>>>>>>>>>>Start RabbitMQ <<<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

echo -e "\e[36m>>>>>>>>>>create one user for the application <<<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"