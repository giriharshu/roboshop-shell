app_user=roboshop

print_head(){
  echo -e "\e[35m>>>>>>>>>> $1 <<<<<<<<<<<\e[0m"
}

schema_setup(){
  echo -e "\e[36m>>>>>>>>>> Copy Mangodb repo <<<<<<<<<<<\e[0m"
  cp ${script_path}/mango.repo /etc/yum.repos.d/mongo.repo

  echo -e "\e[36m>>>>>>>>>> Install Mangodb Client <<<<<<<<<<<\e[0m"
  yum install mongodb-org-shell -y

  mongo --host mangodb-dev.gdevops89.online </app/schema/${component}.js

  systemctl restart ${component}
}

function_nodejs() {
  print_head "Configuring NodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  print_head "Install NodeJS"
  yum install nodejs -y

  print_head "Add User"
  useradd roboshop

  print_head "Add a Directory"
  rm -rf /app
  mkdir /app

  print_head "Unzip App Contents"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app
  unzip /tmp/${component}.zip

  print_head "Install NodeJS dependencies"
  npm install

  print_head "Copy ${component} Systemd file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  systemctl daemon-reload
  systemctl enable ${component}
  systemctl start ${component}

  schema_setup
}