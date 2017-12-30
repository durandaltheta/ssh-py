#!/bin/bash 

# This script builds executable archive files (almost as good as a binary created using a REAL
# LINKER /s). These files (build/ssh and build/ssh3) still have to be executed via a call
# to the python interpreter (a la: python ssh3), but they are completely self contained and 
# usable standalone on other computers that use the same processor family (ie: compile on an intel,
# it should run on a different intel). Also, should theoretically run faster because, well, it's 
# bytecode instead of raw text.

CUR_DIR=$PWD
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SSH_BUILD_PATH=$SCRIPT_DIR/build/ssh-files
SSH3_BUILD_PATH=$SCRIPT_DIR/build/ssh3-files
mkdir -p $SSH_BUILD_PATH
mkdir -p $SSH3_BUILD_PATH

# compile for python2.7 if present
if hash python 2>/dev/null; then
    cd $SCRIPT_DIR/build

    # compile our py files
    python -m py_compile $SCRIPT_DIR/ssh.py 
    python -m py_compile $SCRIPT_DIR/__main__.py  
    mv $SCRIPT_DIR/ssh.pyc $SSH_BUILD_PATH/ssh.pyc
    mv $SCRIPT_DIR/__main__.pyc $SSH_BUILD_PATH/__main__.pyc  

    # copy raw py's if they ever need to be dynamically recompiled
    mv $SCRIPT_DIR/ssh.py $SSH_BUILD_PATH/ssh.py
    mv $SCRIPT_DIR/__main__.py $SSH_BUILD_PATH/__main__.py 

    # copy ssh libraries
    cp -rf $SCRIPT_DIR/paramiko $SSH_BUILD_PATH 

    # assemble python archive
    cd $SSH_BUILD_PATH
    zip -rq ssh *
    mv $SSH_BUILD_PATH/ssh.zip $SCRIPT_DIR/build/ssh
fi

# compile for python3 if present
if hash python3 2>/dev/null; then
    cd $SCRIPT_DIR/build 

    # compile our py files
    python3 $SCRIPT_DIR/compile-ssh3.py $SCRIPT_DIR 
    mv $SCRIPT_DIR/__pycache__/ssh3.cpython-35.opt-2.pyc $SSH3_BUILD_PATH/ssh3.pyc
    mv $SCRIPT_DIR/__pycache__/__main__3.cpython-35.opt-2.pyc $SSH3_BUILD_PATH/__main__3.pyc  

    # copy raw py's if they ever need to be dynamically recompiled
    cp $SCRIPT_DIR/ssh3.py $SSH3_BUILD_PATH
    cp $SCRIPT_DIR/__main__3.py $SSH3_BUILD_PATH 

    # copy ssh libraries
    cp -rf $SCRIPT_DIR/paramiko $SSH3_BUILD_PATH 

    # assemble python archive
    cd $SSH3_BUILD_PATH
    zip -rq ssh3 *
    mv $SSH3_BUILD_PATH/ssh3.zip $SCRIPT_DIR/build/ssh3
fi 

cd $CUR_DIR
