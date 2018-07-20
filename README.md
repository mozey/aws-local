# aws-local

Instructions to run local AWS in Docker with golang examples.

Alternatively use [localstack](https://github.com/localstack/localstack)

This repos is not meant to be a configuration tool like
[docker compose](https://docs.docker.com/compose),
or an orchestration tool like
[kubernetes](https://kubernetes.io/)

It is a collection of simple bash scripts to setup a local dev environment,
that replicates popular AWS services, using standard docker commands.

It is also a cookbook of golang examples demonstrating how to use the services


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

TODO Run examples
    
    gotest -v ${GOPATH}/src/github.com/mozey/aws-local/...
    
    
# Docker Images

#### [DynamoDB](https://github.com/dwmkerr/docker-dynamodb)

Supports all of the commandline parameters in the 
[DynamoDB Documentation](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html)
    
#### [EC2: Ubuntu](https://hub.docker.com/_/ubuntu/)

#### [ES](https://hub.docker.com/_/elasticsearch/)
    
#### [Lambda](https://hub.docker.com/r/lambci/lambda/)

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
    
    docker rm $(docker ps -q -a -f name=elastic)


### DynamoDB 

Shell

    open http://localhost:8000/shell
    
Create table

    aws --endpoint-url http://127.0.0.1:8000 dynamodb create-table \
    --table-name aws-local --attribute-definitions AttributeName=Artist,AttributeType=S \
    --key-schema AttributeName=Artist,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
    
List tables

    aws --endpoint-url http://localhost:8000 dynamodb list-tables
    
Add an item

    aws dynamodb --endpoint-url http://localhost:8000 put-item \
    --table-name aws-local --item file://dynamodb/item.json \
    --return-consumed-capacity TOTAL
    
Inspect db

    sqlite3 ${HOME}/.aws-local/dynamodb/data/shared-local-instance.db
    
    .tables
    
    select * from `aws-local`;
    
    
### ES

Install [httpie](https://httpie.org/)

Get version

    http http://localhost:9200


### RDS: MySQL 

Install client on macOS using Homebrew
    
    brew cask install mysqlworkbench
    
    vi ~/.profile
    # PATH=$PATH:/Applications/MySQLWorkbench.app/Contents/MacOS
        
Connect with client

    # This works, but how to run scripts with `source` cmd?
    docker exec -it mysql mysql -uroot -p
    
    mysql --host=127.0.0.1 --port=3306 -u root -p --binary-mode
    
View logs (if redirected to stderr with MYSQL_LOG_CONSOLE)
    
    docker logs mysql
    
    
### S3: Minio

Create bucket

    aws --endpoint-url=http://127.0.0.1:9000 s3 mb s3://aws-local

List buckets
    
    aws --endpoint-url=http://127.0.0.1:9000 s3 ls
    
Copy local file to a bucket

    aws --endpoint-url=http://127.0.0.1:9000 s3 cp s3/test.json s3://aws-local/test.json
    
Data is persisted on the host

    tree ${HOME}/.aws-local/minio
    
    cat ${HOME}/.aws-local/minio/data/aws-local/test.json
    
    
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
