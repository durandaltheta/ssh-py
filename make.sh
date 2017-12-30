#!/bin/bash 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SSH_BUILD_PATH=$SCRIPT_DIR/"build/ssh-files"
SSH3_BUILD_PATH=$SCRIPT_DIR/"build/ssh3-files"
mkdir -p $SSH_BUILD_PATH
mkdir -p $SSH3_BUILD_PATH
cd $SCRIPT_DIR/build

if hash python 2>/dev/null; then
    python -m py_compile $SCRIPT_DIR/ssh.py 
    python -m py_compile $SCRIPT_DIR/__main__.py 
    mv $SCRIPT_DIR/ssh.pyc $SSH_BUILD_PATH/ssh.pyc
    mv $SCRIPT_DIR/__main__.pyc $SSH_BUILD_PATH/__main__
    chmod +x $SSH_BUILD_PATH/ssh
    cp -rf $SCRIPT_DIR/paramiko $SSH_BUILD_PATH 
    zip -r $SCRIPT_DIR/ssh $SSH_BUILD_PATH
fi

if hash python3 2>/dev/null; then
    python3 $SCRIPT_DIR/compile-ssh3.py $SCRIPT_DIR
    mv $SCRIPT_DIR/__pycache__/ssh3.cpython-35.opt-2.pyc $SSH3_BUILD_PATH/ssh3.pyc
    mv $SCRIPT_DIR/__pycache__/__main__3.cpython-35.opt-2.pyc $SSH3_BUILD_PATH/__main__3.pyc
    chmod +x $SSH3_BUILD_PATH/ssh3
    cp -rf $SCRIPT_DIR/paramiko $SSH3_BUILD_PATH
    zip -r $SCRIPT_DIR/ssh3 $SSH3_BUILD_PATH

fi
