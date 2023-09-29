#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}


yum install nginx -y &>>$LOGFILE

VALIDATE $? "Installing nginx"


systemctl enable nginx &>>$LOGFILE

VALIDATE $? "enabling nginx"


# systemctl start nginx &>>$LOGFILE

# VALIDATE $? "starting nginx"


rm -rf /usr/share/nginx/html/* &>>$LOGFILE

VALIDATE $? "removing default html content in nginx"


curl -o /tmp/web.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$LOGFILE

VALIDATE $? "downloading roboshop artifact"


cd /usr/share/nginx/html &>>$LOGFILE

VALIDATE $? "change directory to html"


unzip /tmp/web.zip &>>$LOGFILE

VALIDATE $? "unzipping the file"


cp /root/roboshop-shell/roboshop.conf  /etc/nginx/default.d/roboshop.conf  &>>$LOGFILE

VALIDATE $? "copying the roboshop.conf file"


systemctl restart nginx &>>$LOGFILE

VALIDATE $? "restarting nginx"




