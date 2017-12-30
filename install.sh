#!/bin/bash 

if [[ $EUID > 0 ]]; then # we can compare directly with this syntax.
    echo "Please run as root/sudo"
    exit 1
else
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    INSTALL_DIR=/usr/local/bin
    mkdir -p $INSTALL_DIR 

    # build self contained archives
    $SCRIPT_DIR/make.sh

    # copy files
    cp $SCRIPT_DIR/build/ssh-py $INSTALL_DIR 
    cp $SCRIPT_DIR/src/pyssh $INSTALL_DIR 
    chmod +x $INSTALL_DIR/pyssh
    cp $SCRIPT_DIR/build/ssh3-py $INSTALL_DIR 
    cp $SCRIPT_DIR/src/pyssh3 $INSTALL_DIR 
    chmod +x $INSTALL_DIR/pyssh3

    # clean directories
    $SCRIPT_DIR/clean.sh
fi
