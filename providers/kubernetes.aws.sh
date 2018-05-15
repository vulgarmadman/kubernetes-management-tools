CONTEXT=$(cat $CONFIG_FILE | $JQ '.["'${index}'"].context')
AUTH=$(cat $CONFIG_FILE | $JQ '.["'${index}'"].auth')

echo "Configuring access to AWS k8s cluster $CONTEXT"
if [ "$AUTH" != "null" ]; then
    echo "Setting AWS access keys from config"
    TMP_KEY=$(cat $CONFIG_FILE | $JQ '.["'${index}'"].auth.aws_access_key_id')
    TMP_SECRET=$(cat $CONFIG_FILE | $JQ '.["'${index}'"].auth.aws_secret_access_key')
    TMP_REGION=$(cat $CONFIG_FILE | $JQ '.["'${index}'"].auth.aws_default_region')
    export AWS_DEFAULT_REGION=${TMP_REGION//\"}
    export AWS_ACCESS_KEY_ID=${TMP_KEY//\"}
    export AWS_SECRET_ACCESS_KEY=${TMP_SECRET//\"}

fi
echo "Exporting NAME=${CONTEXT//\"}"
export NAME=${CONTEXT//\"}
echo "Setting context to $NAME"
kubectl config use-context $NAME
