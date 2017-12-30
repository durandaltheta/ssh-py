#!/bin/bash 

if [[ $EUID > 0 ]]; then # we can compare directly with this syntax.
    echo "Please run as root/sudo"
    exit 1
else  

    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    SRC_DIR=$SCRIPT_DIR/src
    SSH_SRC_PATH=$SRC_DIR/ssh
    SSH3_SRC_PATH=$SRC_DIR/ssh3
    OUTPUT_PATH=$SCRIPT_DIR/build
    INSTALL_DIR=/usr/local/bin 

    if [ ! -f $OUTPUT_PATH/ssh-py ] && [ ! -f $OUTPUT_PATH/ssh-py ]; then
        echo "Please run 'make.sh' as a normal user first"
    fi 

    if [ -f $OUTPUT_PATH/ssh-py ]; then
        mkdir -p $INSTALL_DIR 
        cp $OUTPUT_PATH/ssh-py $INSTALL_DIR 
        cp $SSH_SRC_PATH/pyssh $INSTALL_DIR 
        chmod +x $INSTALL_DIR/pyssh
    fi  

    if [ -f $OUTPUT_PATH/ssh3-py ]; then
        mkdir -p $INSTALL_DIR 
        cp $OUTPUT_PATH/ssh3-py $INSTALL_DIR 
        cp $SSH3_SRC_PATH/pyssh3 $INSTALL_DIR 
        chmod +x $INSTALL_DIR/pyssh3
    fi 

    # clean directories
    $SCRIPT_DIR/clean.sh
fi
