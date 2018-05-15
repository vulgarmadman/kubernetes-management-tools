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
