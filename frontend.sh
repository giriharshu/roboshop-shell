script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

function_print_head "Install Nginx"
yum install nginx -y &>>$log_file
function_stat_check $?

function_print_head "Copy roboshop config file"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
function_stat_check $?

function_print_head "clear old app content"
rm -rf /usr/share/nginx/html/* &>>$log_file
function_stat_check $?

function_print_head "Download App content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
function_stat_check $?

function_print_head "Extracting App content"
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
function_stat_check $?

## Some config files to be create
function_print_head "Start nginx"
systemctl enable nginx $log_file
systemctl start nginx $log_file
systemctl restart nginx $log_file
function_stat_check $?