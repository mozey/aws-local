#!/usr/bin/env bash

# Dir of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Make script executable
chmod u+x ${DIR}/pull.sh
chmod u+x ${DIR}/aws_local.sh
chmod u+x ${DIR}/containers.sh
chmod u+x ${DIR}/user/*.sh

# Create containers,
# downloading the images might take a while
${DIR}/pull.sh
${DIR}/aws_local.sh
${DIR}/containers.sh


