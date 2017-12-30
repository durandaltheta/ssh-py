import sys 
import py_compile 

script_dir = sys.argv[1]
py_compile.compile(script_dir+'/ssh3.py',optimize=2)
py_compile.compile(script_dir+'/__main__3.py',optimize=2)

