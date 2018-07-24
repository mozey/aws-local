#!/usr/bin/env bash

EXPECTED_ARGS=1
E_BADARGS=100

if [ $# -ne ${EXPECTED_ARGS} ]
then
    echo "Get a shell in the specified container"
    echo ""
    echo "Usage:"
    echo "  `basename $0` AWS_LOCAL_NAME"
    echo ""
    echo "Example: "
    echo "  `basename $0` "
    exit ${E_BADARGS}
fi

AWS_LOCAL_NAME="$1"

AWS_LOCAL_COLS=$(tput cols)
AWS_LOCAL_LINES=$(tput lines)

docker exec -it ${AWS_LOCAL_NAME} /bin/bash --version
if [ $? -eq "0" ]
then
    # Use bash if available
    docker exec -it ${AWS_LOCAL_NAME} /bin/bash \
    -c "stty cols ${AWS_LOCAL_COLS} rows ${AWS_LOCAL_LINES} && /bin/bash -l"
else
    docker exec -it ${AWS_LOCAL_NAME} /bin/sh \
    -c "stty cols ${AWS_LOCAL_COLS} rows ${AWS_LOCAL_LINES} && /bin/sh -l"
fi

