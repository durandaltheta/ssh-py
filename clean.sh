#!/bin/bash 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SSH_BUILD_PATH=$SCRIPT_DIR/"build/ssh-files"
SSH3_BUILD_PATH=$SCRIPT_DIR/"build/ssh3-files"
rm -rf $SSH_BUILD_PATH
rm -rf $SSH3_BUILD_PATH

