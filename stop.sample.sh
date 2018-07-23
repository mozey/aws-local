#!/usr/bin/env bash

# DynamoDB
docker stop dynamodb

# RDS: MySQL
docker stop mysql

# S3: minio
docker stop minio

# SES: aws-ses-local
docker stop aws-ses-local

# SQS & SNS: goaws
docker stop goaws
