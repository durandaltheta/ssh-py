#!/bin/bash 

# This script builds executable archive files (almost as good as a binary created using a REAL
# LINKER /s). These files (build/ssh-py and build/ssh3-py) still have to be executed via a call
# to the python interpreter (a la: python ssh3), but they are completely self contained and 
# usable standalone on other computers that use the same processor family (ie: compile on an intel,
# it should run on a different intel). Also, should run faster because, well, it's bytecode instead 
# of raw text.

CUR_DIR=$PWD
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SSH_BUILD_PATH=$SCRIPT_DIR/build/ssh-files
SSH3_BUILD_PATH=$SCRIPT_DIR/build/ssh3-files
mkdir -p $SSH_BUILD_PATH
mkdir -p $SSH3_BUILD_PATH

if hash python 2>/dev/null; then
    cd $SCRIPT_DIR/build
    python -m py_compile $SCRIPT_DIR/ssh.py 
    python -m py_compile $SCRIPT_DIR/__main__.py 
    mv $SCRIPT_DIR/ssh.pyc $SSH_BUILD_PATH/ssh.pyc
    mv $SCRIPT_DIR/__main__.pyc $SSH_BUILD_PATH/__main__.pyc
    chmod +x $SSH_BUILD_PATH/ssh.pyc
    chmod +x $SSH_BUILD_PATH/__main__.pyc 
    mkdir -p $SSH_BUILD_PATH/paramiko
    cp -rf $SCRIPT_DIR/paramiko/*pyc $SSH_BUILD_PATH/paramiko
    cd $SSH_BUILD_PATH
    zip -rq ssh *
    mv $SSH_BUILD_PATH/ssh.zip $SCRIPT_DIR/build/ssh
    chmod +x $SCRIPT_DIR/build/ssh
fi

if hash python3 2>/dev/null; then
    cd $SCRIPT_DIR/build
    python3 $SCRIPT_DIR/compile-ssh3.py $SCRIPT_DIR
    mv $SCRIPT_DIR/__pycache__/ssh3.cpython-35.opt-2.pyc $SSH3_BUILD_PATH/ssh3.pyc
    mv $SCRIPT_DIR/__pycache__/__main__3.cpython-35.opt-2.pyc $SSH3_BUILD_PATH/__main__3.pyc
    chmod +x $SSH3_BUILD_PATH/ssh3.pyc
    chmod +x $SSH3_BUILD_PATH/__main__3.pyc
    mkdir -p $SSH3_BUILD_PATH/paramiko
    cp -rf $SCRIPT_DIR/paramiko/*pyc $SSH3_BUILD_PATH/paramiko
    cd $SSH3_BUILD_PATH
    zip -rq ssh3 *
    mv $SSH3_BUILD_PATH/ssh3.zip $SCRIPT_DIR/build/ssh3
    chmod +x $SCRIPT_DIR/build/ssh3
fi 

cd $CUR_DIR
