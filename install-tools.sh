#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_FILE="$DIR/config.yaml"
YQ="yq"

install_config() {
    if [ -f "$CONFIG_FILE" ]; then
        echo "Moving $CONFIG_FILE to $CONFIG_FILE.bak"
        mv $CONFIG_FILE $CONFIG_FILE.bak
    fi

    echo "Copying $CONFIG_FILE.example file to $CONFIG_FILE"
    cp $CONFIG_FILE.example $CONFIG_FILE
}

do_path_update() {
    echo
    echo "Adding the following to ~/.bash_profile"
    cp ~/.bash_profile ~/.bash_profile.bak
    echo "export PATH=$PATH:$DIR/bin"
    echo "export PATH=$PATH:$DIR/bin" >> ~/.bash_profile
}

update_path() {
    echo "Install tools to your path"
    read -p "Would you like to add these tools to your path (y/n)?" choice
    case "$choice" in
      y|Y ) do_path_update;;
      n|N ) echo "Skipping";;
      * ) echo "invalid" && exit 1;;
    esac
}

check_required() {
    $YQ
    echo $?

    if [ $? -eq 127 ]; then
        echo "yq needs to be installed to process yaml files."
        echo "this can be downloaded from here: https://github.com/kislyuk/yq"
        echo
        exit 1
    fi
}

if [ ! -f "$CONFIG_FILE" ]; then
    install_config
else
    echo "Existing config exists!"
    echo
    read -p "Continue (y/n)?" choice
    case "$choice" in
      y|Y ) install_config;;
      n|N ) exit 1;;
      * ) echo "invalid" && exit 1;;
    esac
fi

check_required
update_path
