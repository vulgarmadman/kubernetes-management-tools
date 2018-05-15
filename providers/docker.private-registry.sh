AUTH=$(cat $CONFIG_FILE | $JQ '.docker["'${index}'"].auth')

if [ "$AUTH" != "null" ]; then
    echo "Logging out of docker..."
    docker logout

    echo "Logged out.  Getting credentials..."
    USERNAME=$(cat $CONFIG_FILE | $JQ '.docker["'${index}'"].auth.username')
    PASSWORD=$(cat $CONFIG_FILE | $JQ '.docker["'${index}'"].auth.password')
    REPOSITORY$(cat $CONFIG_FILE | $JQ '.docker["'${index}'"].repository')

    echo "Logging into Docker Hub"
    echo "Username: $USERNAME"
    echo

    echo ${PASSWORD//\"} | docker login --username ${USERNAME//\"} --password-stdin $REPOSITORY
    echo
fi
