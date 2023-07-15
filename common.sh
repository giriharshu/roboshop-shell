app_user=roboshop
log_file=/tmp/roboshop.log

function_print_head(){
  echo -e "\e[35m>>>>>>>>>> $1 <<<<<<<<<<<\e[0m"
  echo -e "\e[35m>>>>>>>>>> $1 <<<<<<<<<<<\e[0m" &>>$log_file
  #this will differentiat the logs
}

function_stat_check()
{
  if [ $1 -eq 0 ]
  then
      echo -e "\e[35mSUCCESS\e[0m"
    else
      echo -e "\e[32mFAILUR\e[0m"
      echo "Refer the log file /tmp/roboshop.log for more information"
      exit 1
  fi
}

function_schema_setup()
{
  if [ "$schema_setup" == "mongo" ]
  then
   function_print_head "Copy Mangodb repo"
   cp ${script_path}/mango.repo /etc/yum.repos.d/mongo.repo &>>$log_file
   function_stat_check $?

   function_print_head "Install Mangodb Client"
   yum install mongodb-org-shell -y &>>$log_file
   function_stat_check $?

   function_print_head " Load Schema"
   mongo --host mangodb-dev.gdevops89.online </app/schema/${component}.js &>>$log_file
   function_stat_check $?

   systemctl restart ${component} &>>$log_file
   function_stat_check $?
   fi

   if [ "$schema_setup" == "mysql" ]
   then

     function_print_head "Install Mysql"
     yum install mysql -y &>>$log_file
     function_stat_check $?

     function_print_head "Load the Schema"
     mysql -h mysql-dev.gdevops89.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql &>>$log_file
     function_stat_check $?


   fi
}

function_app_prereq()
{
  function_print_head "Add USer"
    id ${app_user} &>>$log_file
    if [ $? -ne 0 ]; then
    useradd ${app_user} &>>$log_file
    fi
    function_stat_check $?

    function_print_head "Create Application Directory"
    rm -rf /app &>>$log_file
    mkdir /app &>>$log_file
    function_stat_check $?

    function_print_head "Download App Contents"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
    function_stat_check $?

    function_print_head "Extract App Contents"
    cd /app
    unzip /tmp/${component}.zip &>>$log_file
    function_stat_check $?
}

function_systemd_setup()
{
    function_print_head "Copy Shipping Systemd file"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
    function_stat_check $?

    function_print_head "Start Shipping Services"
    systemctl daemon-reload &>>$log_file
    systemctl start ${component} &>>$log_file
    systemctl restart ${component} &>>$log_file
    function_stat_check $?
}
function_nodejs()
{
  function_print_head "Configuring NodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
  function_stat_check $?

  function_print_head "Install NodeJS"
  yum install nodejs -y &>>$log_file
  function_stat_check $?

  function_app_prereq

  function_print_head "Install NodeJS dependencies"
  npm install &>>$log_file
  function_stat_check $?

  function_schema_setup

  function_systemd_setup

}

function_java(){

  function_print_head "Install Maven"
  yum install maven -y &>>$log_file
  function_stat_check $?

  function_app_prereq

  function_print_head "Install Maven dependencies"
  mvn clean package &>>$log_file
  function_stat_check $?
  mv target/${component}-1.0.jar ${component}.jar &>>$log_file

  function_schema_setup

  function_systemd_setup
}

function_python(){
  function_print_head "Accept Password"
  sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/${component}.service &>>$log_file
  function_stat_check $?

  function_print_head "Install Python"
  yum install python36 gcc python3-devel -y &>>$log_file
  function_stat_check $?

  function_systemd_setup

  function_print_head "Install Python dependencies"
  pip3.6 install -r requirements.txt &>>$log_file

  function_print_head "Accept Password Input"
  sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/${component}.service &>>$log_file
  function_stat_check $?

  function_systemd_setup
}