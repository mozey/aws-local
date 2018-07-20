#!/usr/bin/env bash

# DynamoDB
docker start dynamodb

# ES
docker start elastic

# RDS: MySQL
docker start mysql

# S3: minio
docker start minio

# SES: aws-ses-local
docker start aws-ses-local

# SQS & SNS: goaws
docker start goaws
