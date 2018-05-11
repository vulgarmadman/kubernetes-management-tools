#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_FILE="$DIR/config.json"
JQ="jq"
CLUSTER_LIST=$(cat $CONFIG_FILE | $JQ ".[].name")
ID=$1

minikube_auth() {
    echo "Cluster-name: minikube"
    echo "Configuring minikube local docker instance for images..."

    eval $(minikube docker-env)
}

gce_auth() {
    KEYFILE=$(cat $CONFIG_FILE | $JQ '.["'${index}'"].auth.key_file')
    PROJECT=$(cat $CONFIG_FILE | $JQ '.["'${index}'"].auth.project_id')
    echo "Keyfile: $KEYFILE"
    echo "Project-Id: $PROJECT"
    echo

    gcloud auth activate-service-account --key-file=${KEYFILE//\"}
    gcloud auth configure-docker
}

selection_auth() {

    while read -r line; do
        counter=$((counter+1))
        echo "$counter) ${line//\"}"
    done <<< "$CLUSTER_LIST"

    counter=0

    read chosen

    while read -r line; do
        counter=$((counter+1))
        if [ "${counter}" == "${chosen}" ]; then
            export index=${line//\"}
            export CLUSTER_NAME=$index
            export PLATFORM=$(cat $CONFIG_FILE | $JQ '.["'${index}'"].platform')

            echo "Configuring docker for use with $index"
            echo "Looking up authentication for $index"
            case "${PLATFORM//\"}" in
                minikube)
                    shift
                    minikube_auth
                    shift
                    ;;
                gcloud)
                    shift
                    gce_auth
                    shift
                    ;;
                *)
                    shift
                    echo "Authentication for $PLATFORM is not configured"
                    exit 1
                    break
                    ;;
            esac

        fi
    done <<< "$CLUSTER_LIST"
}

direct_auth() {
    index=$1

    export CLUSTER_NAME=$index
    export PLATFORM=$(cat $CONFIG_FILE | $JQ '.["'${index}'"].platform')

    if [ "$PLATFORM" == "null" ]; then
        echo "The provided index does not exist in the config file"
        exit 1
    fi

    echo "Configuring docker for use with $index"
    echo "Looking up authentication for $index"
    case "${PLATFORM//\"}" in
        minikube)
            shift
            minikube_auth
            shift
            ;;
        gcloud)
            shift
            gce_auth
            shift
            ;;
        *)
            shift
            echo "Authentication for $PLATFORM is not configured"
            exit 1
            break
            ;;
    esac
}

if [ ! -z "$ID" ]; then
    direct_auth $ID
else
    selection_auth
fi
