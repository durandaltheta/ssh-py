#!/bin/bash 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
mkdir -p $SCRIPT_DIR/build 
cd $SCRIPT_DIR/build

if hash python 2>/dev/null; then
    python -m py_compile $SCRIPT_DIR/ssh.py 
    mv $SCRIPT_DIR/ssh.pyc $SCRIPT_DIR/build/ssh
    chmod +x $SCRIPT_DIR/build/ssh
fi

if hash python3 2>/dev/null; then
    python3 $SCRIPT_DIR/compile-ssh3.py $SCRIPT_DIR
    mv $SCRIPT_DIR/__pycache__/ssh3.cpython-35.opt-2.pyc $SCRIPT_DIR/build/ssh3 
    chmod +x $SCRIPT_DIR/build/ssh3
    rm -rf $SCRIPT_DIR/__pycache__
fi
