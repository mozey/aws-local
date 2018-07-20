#!/usr/bin/env bash

# Create containers

# DynamoDB
docker create --name=dynamodb -p 8000:8000 \
-v ${HOME}/.aws-local/dynamodb/data:/data \
dwmkerr/dynamodb -dbPath /data -sharedDb

# EC2: Ubuntu
# TODO

# ES
# Port 9300 not used, but keep it free in case
docker create --name=elastic -p 9200:9200 \
-v ${HOME}/.aws-local/elastic/data:/usr/share/elasticsearch/data \
elasticsearch:5.6.10

# RDS: MySQL
docker create --name=mysql -p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=asdf \
-e MYSQL_ROOT_HOST=% \
-e MYSQL_LOG_CONSOLE=true \
--mount type=bind,src=${HOME}/.aws-local/mysql/data,dst=/var/lib/mysql \
mysql/mysql-server:5.6

# S3: minio
# Port 9000 is used for PHP xdebug
docker create --name=minio -p 9002:9000 \
-e MINIO_ACCESS_KEY=asdf \
-e MINIO_SECRET_KEY=asdfasdf \
-v ${HOME}/.aws-local/minio/data:/data \
minio/minio server /data

# SES: aws-ses-local
docker create --name=aws-ses-local -p 9001:9001 \
-v ${HOME}/.aws-local/aws-ses-local/data:/aws-ses-local/output \
jdelibas/aws-ses-local

# SQS & SNS: goaws
docker create --name goaws -p 4100:4100 pafortin/goaws

