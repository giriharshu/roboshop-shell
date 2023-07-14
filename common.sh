app_user=roboshop

function_print_head(){
  echo -e "\e[35m>>>>>>>>>> $1 <<<<<<<<<<<\e[0m"
}

function_schema_setup(){
  if [ "$schema_setup" == "mongo" ]
  then
   function_print_head "Copy Mangodb repo"
   cp ${script_path}/mango.repo /etc/yum.repos.d/mongo.repo

   function_print_head "Install Mangodb Client"
   yum install mongodb-org-shell -y

   function_print_head " Load Schema"

   mongo --host mangodb-dev.gdevops89.online </app/schema/${component}.js

   systemctl restart ${component}
   fi

   if [ "$schema_setup" == "mysql" ]
   then
     function_print_head "Load the Schema"
       mysql -h mysql-dev.gdevops89.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql

       function_print_head "Install Mysql"
       yum install mysql -y
   fi
}

function_app_prereq()
{
  function_print_head "Add USer"
    useradd roboshop

    function_print_head "Create Application Directory"
    rm -rf /app
    mkdir /app

    function_print_head "Unzip App Contents" <<<<<<<<<<<\e[0m""
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
    cd /app
    unzip /tmp/${component}.zip
}

function_systemd_setup()
{
    function_print_head "Copy Shipping Systemd file"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

    function_print_head "Start Shipping Services"
    systemctl daemon-reload
    systemctl start ${component}
    systemctl restart ${component}
}
function_nodejs()
{
  function_print_head "Configuring NodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  function_print_head "Install NodeJS"
  yum install nodejs -y

  function_app_prereq

  function_print_head "Install NodeJS dependencies"
  npm install

  function_schema_setup

  function_systemd_setup

}

function_java()
{
  function_print_head "Install Maven"
  yum install maven -y

  function_app_prereq

  function_print_head "Install Maven dependencies"
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar

  function_schema_setup

  function_systemd_setup
}