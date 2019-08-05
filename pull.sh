#!/usr/bin/env bash

# Make sure images are available locally and up to date

# DynamoDB
docker pull dwmkerr/dynamodb

# EC2: LAMP
# Ubuntu 16.04 is current LTS version
#docker pull ubuntu:16.04

# ES
docker pull elasticsearch:5.6.10
# Migrate to using OpenDistro for ES
docker pull amazon/opendistro-for-elasticsearch:1.1.0

# Lambda
docker pull lambci/lambda

# RDS: MySQL
# MySQL 5.7 is also supported
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html
docker pull mysql/mysql-server:5.6

# S3
docker pull minio/minio

# SES
docker pull jdelibas/aws-ses-local

# SQS & SNS
docker pull pafortin/goaws

