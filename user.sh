script=$(realpath "$0")
echo ${script}
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=user

function_nodejs

echo -e "\e[36m>>>>>>>>>> Copy Mangodb repo <<<<<<<<<<<\e[0m"
cp ${script_path}/mango.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>> Install Mangodb Client <<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

mongo --host mangodb-dev.gdevops89.online </app/schema/user.js

systemctl restart user

