#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_FILE="$DIR/config.json"
JQ="jq"
AUTH_BASE=""
CLUSTER_LIST=$(cat $CONFIG_FILE | $JQ ".[].name")
CLUSTER_ID=$1

minikube_auth() {
    echo "Cluster-name: minikube"
    echo "Standalone authentication (not on GCE)"
    kubectl config use-context minikube
}

gce_auth() {
    ZONE=$(cat $CONFIG_FILE | $JQ '.["'${index}'"].auth.zone')
    KEYFILE=$(cat $CONFIG_FILE | $JQ '.["'${index}'"].auth.key_file')
    PROJECT=$(cat $CONFIG_FILE | $JQ '.["'${index}'"].auth.project_id')
    GKE_CLUSTER=$(cat $CONFIG_FILE | $JQ '.["'${index}'"].auth.cluster_name')
    echo "Cluster-name: $GKE_CLUSTER"
    echo "Zone: $ZONE"
    echo "Keyfile: $KEYFILE"
    echo "Project-Id: $PROJECT"
    echo
    gcloud auth activate-service-account --key-file ${KEYFILE//\"}
    gcloud container clusters get-credentials ${GKE_CLUSTER//\"} --zone ${ZONE//\"} --project ${PROJECT//\"}
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
            export PLATFORM=$(cat $CONFIG_FILE | $JQ '.["'${index}'"].platform')

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
        *)
            shift
            echo "Authentication for $PLATFORM is not configured"
            exit 1
            break
            ;;
    esac
}

if [ ! -z "$CLUSTER_ID" ]; then
    direct_auth $CLUSTER_ID
else
    get_cluster_list
fi
