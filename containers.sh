#!/usr/bin/env bash

# Create containers

# DynamoDB
docker rm dynamodb
docker create --name=dynamodb -p 8000:8000 \
-v ${HOME}/.aws-local/dynamodb/data:/data \
dwmkerr/dynamodb -dbPath /data -sharedDb

# ES
docker rm elastic
docker create --name=elastic -p 9200:9200 \
-v ${HOME}/.aws-local/elastic/data:/usr/share/elasticsearch/data \
elasticsearch:5.6.10

# ES: OpenDistro
# TODO Only works for port 9200?
docker rm opendistro
docker create --name=opendistro -p 9200:9200 \
-v ${HOME}/.aws-local/opendistro/data:/usr/share/elasticsearch/data \
-e "discovery.type=single-node" \
amazon/opendistro-for-elasticsearch:1.1.0

# RDS: MySQL
docker rm mysql
docker create --name=mysql -p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=asdf \
-e MYSQL_ROOT_HOST=% \
-e MYSQL_LOG_CONSOLE=true \
--mount type=bind,src=${HOME}/.aws-local/mysql/data,dst=/var/lib/mysql \
mysql/mysql-server:5.6

# S3: minio
# Port 9000 is used for PHP xdebug
docker rm minio
docker create --name=minio -p 9002:9000 \
-e MINIO_ACCESS_KEY=asdf \
-e MINIO_SECRET_KEY=asdfasdf \
-v ${HOME}/.aws-local/minio/data:/data \
minio/minio server /data

# SES: aws-ses-local
docker rm aws-ses-local
docker create --name=aws-ses-local -p 9001:9001 \
-v ${HOME}/.aws-local/aws-ses-local/data:/aws-ses-local/output \
jdelibas/aws-ses-local

# SQS & SNS: goaws
docker rm goaws
docker create --name goaws -p 4100:4100 pafortin/goaws

