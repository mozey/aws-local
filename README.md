# aws-local

Instructions to setup AWS services locally with usage examples


# Install

### [Install Docker](https://docs.docker.com/install)

### Install all the services 

Run the start script

    $GOPATH/src/github.com/mozey/aws-local/start.sh
    
### Install services individually

#### [DynamoDB](https://github.com/dwmkerr/docker-dynamodb)

    mkdir -p ~/.aws-local/dynamodb/data
    
    docker run --name=dynamodb -d -p 8000:8000 \
    -v ${HOME}/.aws-local/dynamodb/data:/data \
    dwmkerr/dynamodb -dbPath /data -sharedDb    

#### [RDS: Postgres](https://hub.docker.com/_/postgres)

    TODO...

#### [RDS: MySQL](https://hub.docker.com/r/mysql/mysql-server)

[Persisting data and config](https://dev.mysql.com/doc/refman/5.7/en/docker-mysql-more-topics.html#docker-persisting-data-configuration)

    mkdir -p ~/.aws-local/mysql/data
    
    #touch ~/.aws-local/mysql/my.cnf
    
    docker run --name=mysql -d -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD=asdf \
    -e MYSQL_ROOT_HOST=% \
    -e MYSQL_LOG_CONSOLE=true \
    --mount type=bind,src=${HOME}/.aws-local/mysql/data,dst=/var/lib/mysql \
    mysql/mysql-server:5.6

#### [S3: Minio](https://github.com/minio/minio)

    mkdir -p ~/.aws-local/minio/data
    
    docker run --name=minio -d -p 9000:9000 \
    minio/minio server ~/.aws-local/minio/data
    
#### [SES: aws-ses-local](https://hub.docker.com/r/jdelibas/aws-ses-local)

    mkdir -p ~/.aws-local/aws-ses-local/data
    
    docker run --name=aws-ses-local -d -p 9001:9001 jdelibas/aws-ses-local

#### [SQS & SNS: goaws](https://github.com/p4tin/goaws)

    mkdir -p ~/.aws-local/goaws/data
    
    docker run --name goaws -d -p 4100:4100 pafortin/goaws


# Test

Start local services

    $GOPATH/src/github.com/mozey/aws-local/start.sh

Run `golang` examples

    go get github.com/mozey/aws-local

    gotest -v $GOPATH/src/github.com/mozey/aws-local/...


# AWS command line

[Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)


# Misc

### Docker

Stop all running docker containers

    docker stop $(docker ps -q)
    
Remove all containers,
persistent volumes should be mapped from host 

    docker rm $(docker ps -q -a)

### DynamoDB 

Shell

    open http://localhost:8000/shell

### MySQL 

Install client on macOS using Homebrew
    
    #brew install mysql-utilities
    brew cask install mysqlworkbench
    
    PATH=$PATH:/Applications/MySQLWorkbench.app/Contents/MacOS
    
View logs (if redirected to stderr with MYSQL_LOG_CONSOLE)
    
    docker logs
    
Connect with client

    # This works, but can't run scripts with `source`?
    docker exec -it mysql mysql -uroot -p
    
    mysql --host=127.0.0.1 --port=3306 -u root -p
    
