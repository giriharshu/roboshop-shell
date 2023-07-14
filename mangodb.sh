
function_print_head "Setup mango repo"
cp mango.repo /etc/yum.repos.d/mongo.repo >>$log_file
function_stat_check $?

function_print_head "Install Mangod"
yum install mongodb-org -y >>$log_file
function_stat_check $?


function_print_head "Update Mangod Listen Address"
## Edit the file and replace 122.0.0.1 with 0.0.0.0
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf >>$log_file
function_stat_check $?

function_print_head "Start Mangod"
systemctl enable mongod >>$log_file
systemctl start mongod >>$log_file
systemctl restart mongod >>$log_file
function_stat_check $?