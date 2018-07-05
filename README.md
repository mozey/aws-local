# aws-local

Instructions to run local AWS in Docker with golang examples

Alternatively use [localstack](https://github.com/localstack/localstack)


# Install

### [Install Docker](https://docs.docker.com/install)

### [Install golang](https://golang.org/doc/install)

### Create docker containers

Get aws-local

    go get github.com/mozey/aws-local

Run the install script

    ${GOPATH}/src/github.com/mozey/aws-local/install.sh
    
Persistent data is easily accessible from the host

    tree -L 2 ~/.aws-local

    
# Test

Start local services

    ${GOPATH}/src/github.com/mozey/aws-local/start.sh
    
    docker ps
    
go test with colors

    go get -u github.com/rakyll/gotest

Run examples
    
    gotest -v ${GOPATH}/src/github.com/mozey/aws-local/...
    
    
# Docker Images

#### [DynamoDB](https://github.com/dwmkerr/docker-dynamodb)
    
#### [EC2: Ubuntu](https://hub.docker.com/_/ubuntu/)
    
### [Lambda](https://hub.docker.com/r/lambci/lambda/)

#### [RDS: Postgres](https://hub.docker.com/_/postgres)

#### [RDS: MySQL](https://hub.docker.com/r/mysql/mysql-server)

[Persisting data and config](https://dev.mysql.com/doc/refman/5.7/en/docker-mysql-more-topics.html#docker-persisting-data-configuration)

#### [S3: minio](https://github.com/minio/minio)

#### [SES: aws-ses-local](https://hub.docker.com/r/jdelibas/aws-ses-local)

Writes email html, text and headers to file

#### [SQS & SNS: goaws](https://github.com/p4tin/goaws)

[Persisting data](https://github.com/p4tin/goaws/issues/169)


# Misc

### AWS CLI

[Install](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)

Setup credentials

    aws configure --profile aws-local
    # AWS Access Key ID [None]: asdf
    # AWS Secret Access Key [None]: asdfasdf
    # Default region name [None]: eu-west-1
    # Default output format [None]: json

Select profile

    export AWS_PROFILE=aws-local


### Docker

List images

    docker image ls

Stop all running containers

    docker stop $(docker ps -q)
    
Remove all containers,
persistent volumes should be mapped from host 

    docker rm $(docker ps -q -a)


### DynamoDB 

Shell

    open http://localhost:8000/shell


### RDS: MySQL 

Install client on macOS using Homebrew
    
    brew cask install mysqlworkbench
    
    vi ~/.profile
    # PATH=$PATH:/Applications/MySQLWorkbench.app/Contents/MacOS
        
Connect with client

    # This works, but how to run scripts with `source` cmd?
    docker exec -it mysql mysql -uroot -p
    
    mysql --host=127.0.0.1 --port=3306 -u root -p
    
View logs (if redirected to stderr with MYSQL_LOG_CONSOLE)
    
    docker logs mysql
    
    
### S3: Minio

Create bucket

    aws --endpoint-url=http://127.0.0.1:9000 s3 mb s3://aws-local

List buckets
    
    aws --endpoint-url=http://127.0.0.1:9000 s3 ls
    
    
### SES: aws-ses-local

Send email

    aws --endpoint-url http://127.0.0.1:9001 ses send-email \
    --from sender@example.com --destination file://ses/destination.json \
    --message file://ses/message.json

List results

    tree ${HOME}/.aws-local/aws-ses-local/data
    
    
### SQS & SNS: Goaws

Create queue

    aws --endpoint-url http://127.0.0.1:4100 sqs create-queue --queue-name aws-local
    
List queues

    aws --endpoint-url http://127.0.0.1:4100 sqs list-queues
