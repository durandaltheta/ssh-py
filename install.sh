#!/bin/bash 

if [[ $EUID > 0 ]]; then # we can compare directly with this syntax.
    echo "Please run as root/sudo"
    exit 1
else
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    mkdir -p /usr/local/bin 

    # copy files
    cp $SCRIPT_DIR/ssh-py /usr/local/bin 
    cp $SCRIPT_DIR/ssh.py /usr/local/bin 
    cp $SCRIPT_DIR/ssh-py3 /usr/local/bin 
    cp $SCRIPT_DIR/ssh3.py /usr/local/bin 
    cp -r $SCRIPT_DIR/paramiko /usr/local/bin
fi
