script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

mysql_root_password=$1

if [ -z "$mysql_root_password" ]
then
  echo input mysql root password missing
  exit
fi

function_print_head "disable MySQL 8 version"
yum module disable mysql -y &>>$log_file
function_stat_check $?

function_print_head "Setup the MySQL repo file"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
function_stat_check $?

function_print_head "Install MySQL Server"
yum install mysql-community-server -y &>>$log_file
function_stat_check $?

function_print_head "change the default root password"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$log_file
function_stat_check $?

function_print_head
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
function_stat_check $?



#mysql -uroot -pRoboShop@1