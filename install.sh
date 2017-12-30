#!/bin/bash 

if [[ $EUID > 0 ]]; then # we can compare directly with this syntax.
    echo "Please run as root/sudo"
    exit 1
else
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    mkdir -p /usr/local/bin 

    # build self contained archives
    $SCRIPT_DIR/make.sh

    # copy files
    cp $SCRIPT_DIR/src/ssh-py /usr/local/bin 
    cp $SCRIPT_DIR/build/pyssh /usr/local/bin 
    cp $SCRIPT_DIR/src/ssh-py3 /usr/local/bin 
    cp $SCRIPT_DIR/build/pyssh3 /usr/local/bin 

    # clean directories
    $SCRIPT_DIR/clean.sh
fi
