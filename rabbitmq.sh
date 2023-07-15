script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]
then
  echo input rabbitmq appuser password missing
fi

function_print_head "Configure YUM Repos from the script provided by vendor"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
function_stat_check $?

function_print_head "Configure YUM Repos for RabbitMQ"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
function_stat_check $?

function_print_head "Install RabbitMQ"
yum install rabbitmq-server -y &>>$log_file
function_stat_check $?

function_print_head "Start RabbitMQ"
systemctl enable rabbitmq-server &>>$log_file
systemctl start rabbitmq-server &>>$log_file
function_stat_check $?

function_print_head "create one user for the application"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password} &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
function_stat_check $?



