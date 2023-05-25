cp mango.repo /etc/yum.repos.d/mongo.repo

yum install mongodb-org -y

systemctl enable mongod
systemctl start mongod

## Edit the file and replace 122.0.0.1 with 0.0.0.0

systemctl restart mongod