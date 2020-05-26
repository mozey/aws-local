#!/usr/bin/env bash
set -eu # exit on error or undefined variable
bash -c 'set -o pipefail' # return code of first cmd to fail in a pipeline

EXPECTED_ARGS=1

if [[ $# -lt ${EXPECTED_ARGS} ]]
then
  echo "Usage:"
  echo "  `basename $0` TARGET [...]"
  echo ""
  echo "Kibana using just docker commands"
  echo "https://discuss.opendistrocommunity.dev/t/opendistro-elastic-and-kibana-in-docker/1915/2"
  echo ""
  echo "Examples:"
  echo "  `basename $0` up"
  echo "  `basename $0` down"
  echo "  `basename $0` depends docker"
  exit 1
fi

TARGET=${1}

VERSION="1.4.0"
#SUDO="sudo "
SUDO=""

# Depends lists, and can be used to check for, programs this script depends on
depends() {
    if [[ ${1} == "docker" ]]; then
        ${SUDO}docker version >/dev/null 2>&1 || \
        { printf >&2 \
            "Install https://www.docker.com\n"; exit 1; }

    else
        echo "unknown dependency ${1}"
        exit 1
    fi
}

# Start container if not running
start_container() {
    if [[ $(${SUDO}docker ps -f "name=${1}" -q) ]]; then
        echo "container is already running ${1}"
    else
        echo "starting container..."
        ${SUDO}docker start ${1}
    fi
}

# Stop container if running
stop_container() {
    if [[ $(${SUDO}docker ps -f "name=${1}" -q) ]]; then
        echo "stopping container..."
        ${SUDO}docker stop ${1}
    else
        echo "container is not running ${1}"
    fi
}

rm_container() {
    echo ${FUNCNAME}
    if [[ $(${SUDO}docker ps -a -f "name=${1}" -q) ]]; then
        echo "removing container..."
        ${SUDO}docker rm ${1}
    else
        echo "container does not exist ${1}"
    fi
}

create_opendistro() {
    echo ${FUNCNAME}
    NAME="opendistro"
    # Create data dir if not exists
    HOME=${HOME}
    DATA_DIR=${HOME}/.aws-local/opendistro
    if [[ ! -d "${DATA_DIR}" ]]; then
        mkdir -p ${DATA_DIR}
        # Set permissions
#        USER=${USER}
#        GROUP="xxx"
#        chown -R ${USER}:${GROUP} ${HOME}/.aws-local
#        chmod 755 ${HOME}/.aws-local
        # Set directories to 755 but files to 644.
        # Note this does not reset previous 777
        # https://superuser.com/a/91966/537059
#        chmod -R u+rwX,go+rX,go-w ${HOME}/.aws-local/opendistro
    fi
    # Create container
    ${SUDO}docker create --name=${NAME} -p 9200:9200 \
    -v ${HOME}/.aws-local/opendistro/data:/usr/share/elasticsearch/data:cached \
    -e "discovery.type=single-node" \
    amazon/opendistro-for-elasticsearch:${VERSION}
}

create_kibana() {
    echo ${FUNCNAME}
    NAME="opendistro"
    if [[ $(${SUDO}docker ps -f "name=${NAME}" -q) ]]; then
        ELASTIC_IP=$(${SUDO}docker inspect -f \
            '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
            opendistro)
        NAME="kibana"
        ${SUDO}docker create --name=${NAME} -p 5601:5601 \
        -e "ELASTICSEARCH_URL=https://${ELASTIC_IP}" \
        -e "ELASTICSEARCH_HOSTS=https://${ELASTIC_IP}:9200" \
        amazon/opendistro-for-elasticsearch-kibana:${VERSION}
    else
        echo "opendistro is not running"
        exit 1
    fi
}

create() {
    echo ${FUNCNAME}
    create_opendistro
    start_container opendistro
    create_kibana
}

reset() {
    echo ${FUNCNAME}
    down
    rm_container opendistro
    rm_container kibana
}

up() {
    echo ${FUNCNAME}
    depends docker
    NAME="opendistro"
    if [[ $(${SUDO}docker ps -a -f "name=${NAME}" -q) ]]; then
        echo "using existing container for ${NAME}"
    else
        create_opendistro
    fi
    start_container opendistro
    NAME="kibana"
    if [[ $(${SUDO}docker ps -a -f "name=${NAME}" -q) ]]; then
        echo "using existing container ${NAME}"
    else
        create_kibana
    fi
    start_container kibana
}

down() {
    echo ${FUNCNAME}
    depends docker
    stop_container opendistro
    stop_container kibana
}

# Execute target if it's a func defined in this script.
TYPE=$(type -t ${TARGET} || echo "undefined")
if [[ ${TYPE} == "function" ]]; then
    # Additional arguments, after the target, are passed through
    ${TARGET} ${@:2}
else
    echo "TARGET ${TARGET} not implemented"
    exit 1
fi
