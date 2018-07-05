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

    $GOPATH/src/github.com/mozey/aws-local/install.sh
    
Persistent data is easily accessible from the host

    ls ~/.aws-local

    
# Test

Start local services

    $GOPATH/src/github.com/mozey/aws-local/start.sh
    
go test with colors

    go get -u github.com/rakyll/gotest

Run examples
    
    gotest -v $GOPATH/src/github.com/mozey/aws-local/...
    
    
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


# AWS command line

[Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)


# Misc

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


### MySQL 

Install client on macOS using Homebrew
    
    brew cask install mysqlworkbench
    
    vi ~/.profile
    # PATH=$PATH:/Applications/MySQLWorkbench.app/Contents/MacOS
    
View logs (if redirected to stderr with MYSQL_LOG_CONSOLE)
    
    docker logs
    
Connect with client

    # This works, but how to run scripts with `source` cmd?
    docker exec -it mysql mysql -uroot -p
    
    mysql --host=127.0.0.1 --port=3306 -u root -p
    
    
### Minio

List buckets

    aws --endpoint-url=http://127.0.0.1:9000 s3 ls