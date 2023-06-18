app_user=roboshop

print_heade(){
  echo -e "\e[35m>>>>>>>>>> $1 <<<<<<<<<<<\e[0m"
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

  print_head "Copy Cart Systemd file"
  cp ${script_path}/cart.service /etc/systemd/system/${component}.service

  systemctl daemon-reload
  systemctl enable ${component}
  systemctl start ${component}
}