KEYFILE=$(cat $CONFIG_FILE | $JQ '.docker["'${index}'"].auth.key_file')
PROJECT=$(cat $CONFIG_FILE | $JQ '.docker["'${index}'"].auth.project_id')
echo "Keyfile: $KEYFILE"
echo "Project-Id: $PROJECT"
echo

gcloud auth activate-service-account --key-file=${KEYFILE//\"}
gcloud auth configure-docker
