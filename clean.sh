#!/bin/bash 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SSH3_SRC_PATH=$SRC_DIR/ssh3
SSH_BUILD_PATH=$SSH_SRC_PATH/build
SSH3_BUILD_PATH=$SSH3_SRC_PATH/build 
OUTPUT_PATH=$SCRIPT_DIR/build
rm -rf $SSH_BUILD_PATH
rm -rf $SSH3_BUILD_PATH 
rm -rf $SSH3_SRC_PATH/__pycache__
rm -rf $OUTPUT_PATH

