#!/bin/bash 

# compiles ssh.py and ssh3.py in self contained archives of python bytecode, respectively
# ssh-py and ssh3-py. Not technically a real binary file because it is not assembled via 
# a linker, it is self contained and portable. They must still be executed via the python 
# (for ssh-py) or python3 (for ssh3-py) commands respectively.

CUR_DIR=$PWD
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRC_DIR=$SCRIPT_DIR/src
SSH_SRC_PATH=$SRC_DIR/ssh
SSH3_SRC_PATH=$SRC_DIR/ssh3
SSH_BUILD_PATH=$SSH_SRC_PATH/build
SSH3_BUILD_PATH=$SSH3_SRC_PATH/build 
OUTPUT_PATH=$SCRIPT_DIR/build
mkdir -p $SSH_BUILD_PATH
mkdir -p $SSH3_BUILD_PATH
mkdir -p $OUTPUT_PATH

# compile for python2.7 if present
if hash python 2>/dev/null; then
    cd $SSH_SRC_PATH 

    # compile our py files 
    python -m py_compile ssh.py 
    python -m py_compile __main__.py  
    chmod 755 ssh.pyc
    chmod 755 __main__.py
    mv ssh.pyc $SSH_BUILD_PATH/ssh.pyc
    mv __main__.pyc $SSH_BUILD_PATH/__main__.pyc  

    # copy raw py's if they ever need to be dynamically recompiled
    cp -p ssh.py $SSH_BUILD_PATH/ssh.py
    cp -p __main__.py $SSH_BUILD_PATH/__main__.py 

    # copy ssh libraries
    cp -rfp $SRC_DIR/paramiko $SSH_BUILD_PATH 

    # assemble python archive
    cd $SSH_BUILD_PATH
    zip -rq ssh *
    mv ssh.zip $OUTPUT_PATH/ssh-py
fi

# compile for python3 if present
if hash python3 2>/dev/null; then
    cd $SSH3_SRC_PATH 

    # compile our py files
    python3 compile-ssh3.py $SSH3_SRC_PATH
    chmod 755 __pycache__/ssh3.cpython-35.opt-2.pyc
    chmod 755 __pycache__/__main__3.cpython-35.opt-2.pyc
    mv __pycache__/ssh3.cpython-35.opt-2.pyc $SSH3_BUILD_PATH/ssh3.pyc
    mv __pycache__/__main__3.cpython-35.opt-2.pyc $SSH3_BUILD_PATH/__main__3.pyc  

    # copy raw py's if they ever need to be dynamically recompiled
    cp -p ssh3.py $SSH3_BUILD_PATH
    cp -p __main__3.py $SSH3_BUILD_PATH/__main__.py

    # copy ssh libraries
    cp -rfp $SRC_DIR/paramiko $SSH3_BUILD_PATH 

    # assemble python archive
    cd $SSH3_BUILD_PATH
    zip -rq ssh3 *
    mv ssh3.zip $OUTPUT_PATH/ssh3-py
fi 

cd $CUR_DIR
