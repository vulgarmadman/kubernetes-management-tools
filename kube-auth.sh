#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_FILE="$DIR/config.yaml"
JQ="yq"
CLUSTER_LIST=$(cat $CONFIG_FILE | $JQ ".kubernetes[].name")
CLUSTER_ID=$1
PROVIDERS="$DIR/providers"

# Providers
minikube_auth() {
    source $PROVIDERS/kubernetes.minikube.sh
}
aws_auth() {
    source $PROVIDERS/kubernetes.aws.sh
}
gce_auth() {
    source $PROVIDERS/kubernetes.gcloud.sh
}

selection_list() {
    #PLATFORM=$1
    echo "Switching to $CLUSTER_NAME cluster"
    echo "Looking up authentication for $CLUSTER_NAME"
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
        aws)
            shift
            aws_auth
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

get_cluster_list() {
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
            export PLATFORM=$(cat $CONFIG_FILE | $JQ '.kubernetes["'${index}'"].platform')

            selection_list

        fi
    done <<< "$CLUSTER_LIST"
}

direct_auth() {
    index=$1

    export CLUSTER_NAME=$index
    export PLATFORM=$(cat $CONFIG_FILE | $JQ '.kubernetes["'${index}'"].platform')

    if [ "$PLATFORM" == "null" ]; then
        echo "The provided index does not exist in the config file"
        exit 1
    fi

    selection_list
}

if [ ! -z "$CLUSTER_ID" ]; then
    direct_auth $CLUSTER_ID
else
    get_cluster_list
fi
