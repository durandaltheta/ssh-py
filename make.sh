#!/bin/bash 

# compiles ssh.py and ssh3.py in self contained archives of python bytecode. Not technically
# a real binary file because it is not assembled via a linker, it is self contained and 
# portable. They must still be executed via the python (for ssh) or python3 (for ssh3) 
# commands respectively

CUR_DIR=$PWD
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRC_DIR=$SCRIPT_DIR/src
SSH_BUILD_PATH=$SCRIPT_DIR/build/ssh-files
SSH3_BUILD_PATH=$SCRIPT_DIR/build/ssh3-files
mkdir -p $SSH_BUILD_PATH
mkdir -p $SSH3_BUILD_PATH

# compile for python2.7 if present
if hash python 2>/dev/null; then
    # compile our py files
    python -m py_compile $SRC_DIR/ssh.py 
    python -m py_compile $SRC_DIR/__main__.py  
    mv $SRC_DIR/ssh.pyc $SSH_BUILD_PATH/ssh.pyc
    mv $SRC_DIR/__main__.pyc $SSH_BUILD_PATH/__main__.pyc  

    # copy raw py's if they ever need to be dynamically recompiled
    cp $SRC_DIR/ssh.py $SSH_BUILD_PATH/ssh.py
    cp $SRC_DIR/__main__.py $SSH_BUILD_PATH/__main__.py 

    # copy ssh libraries
    cp -rf $SRC_DIR/paramiko $SSH_BUILD_PATH 

    # assemble python archive
    cd $SSH_BUILD_PATH
    zip -rq ssh *
    mv $SSH_BUILD_PATH/ssh.zip $SCRIPT_DIR/build/ssh-py
fi

# compile for python3 if present
if hash python3 2>/dev/null; then
    # compile our py files
    python3 $SRC_DIR/compile-ssh3.py $SRC_DIR 
    mv $SRC_DIR/__pycache__/ssh3.cpython-35.opt-2.pyc $SSH3_BUILD_PATH/ssh3.pyc
    mv $SRC_DIR/__pycache__/__main__3.cpython-35.opt-2.pyc $SSH3_BUILD_PATH/__main__3.pyc  

    # copy raw py's if they ever need to be dynamically recompiled
    cp $SRC_DIR/ssh3.py $SSH3_BUILD_PATH
    cp $SRC_DIR/__main__3.py $SSH3_BUILD_PATH/__main__.py

    # copy ssh libraries
    cp -rf $SRC_DIR/paramiko $SSH3_BUILD_PATH 

    # assemble python archive
    cd $SSH3_BUILD_PATH
    zip -rq ssh3 *
    mv $SSH3_BUILD_PATH/ssh3.zip $SCRIPT_DIR/build/ssh3-py
fi 

cd $CUR_DIR
