import os
import sys
import threading
import paramiko
import argparse
import getpass 
import os
import shlex
import struct
import platform
import subprocess
 
 
def get_terminal_size():
    """ getTerminalSize()
     - get width and height of console
     - works on linux,os x,windows,cygwin(windows)
     originally retrieved from:
     http://stackoverflow.com/questions/566746/how-to-get-console-window-width-in-python
    """
    current_os = platform.system()
    tuple_xy = None
    if current_os == 'Windows':
        tuple_xy = _get_terminal_size_windows()
        if tuple_xy is None:
            tuple_xy = _get_terminal_size_tput()
            # needed for window's python in cygwin's xterm!
    if current_os in ['Linux', 'Darwin'] or current_os.startswith('CYGWIN'):
        tuple_xy = _get_terminal_size_linux()
    if tuple_xy is None:
        print "default"
        tuple_xy = (80, 25)      # default value
    return tuple_xy
 
 
def _get_terminal_size_windows():
    try:
        from ctypes import windll, create_string_buffer
        # stdin handle is -10
        # stdout handle is -11
        # stderr handle is -12
        h = windll.kernel32.GetStdHandle(-12)
        csbi = create_string_buffer(22)
        res = windll.kernel32.GetConsoleScreenBufferInfo(h, csbi)
        if res:
            (bufx, bufy, curx, cury, wattr,
             left, top, right, bottom,
             maxx, maxy) = struct.unpack("hhhhHhhhhhh", csbi.raw)
            sizex = right - left + 1
            sizey = bottom - top + 1
            return sizex, sizey
    except:
        pass
 

def _get_terminal_size_tput():
    # get terminal width
    # src: http://stackoverflow.com/questions/263890/how-do-i-find-the-width-height-of-a-terminal-window
    try:
        cols = int(subprocess.check_call(shlex.split('tput cols')))
        rows = int(subprocess.check_call(shlex.split('tput lines')))
        return (cols, rows)
    except:
        pass
 
 
def _get_terminal_size_linux():
    def ioctl_GWINSZ(fd):
        try:
            import fcntl
            import termios
            cr = struct.unpack('hh',
                               fcntl.ioctl(fd, termios.TIOCGWINSZ, '1234'))
            return cr
        except:
            pass
    cr = ioctl_GWINSZ(0) or ioctl_GWINSZ(1) or ioctl_GWINSZ(2)
    if not cr:
        try:
            fd = os.open(os.ctermid(), os.O_RDONLY)
            cr = ioctl_GWINSZ(fd)
            os.close(fd)
        except:
            pass
    if not cr:
        try:
            cr = (os.environ['LINES'], os.environ['COLUMNS'])
        except:
            return None
    return int(cr[1]), int(cr[0])
 
if __name__ == "__main__":
    sizex, sizey = get_terminal_size()
    print  'width =', sizex, 'height =', sizey

class _Getch:
    """Gets a single character from standard input.  Does not echo to the
screen."""
    def __init__(self):
        try:
            self.impl = _GetchWindows()
        except ImportError:
            self.impl = _GetchUnix()

    def __call__(self): return self.impl()


class _GetchUnix:
    def __init__(self):
        import tty, sys

    def __call__(self):
        import sys, tty, termios
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(sys.stdin.fileno())
            ch = sys.stdin.read(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        return ch


class _GetchWindows:
    def __init__(self):
        import msvcrt

    def __call__(self):
        import msvcrt
        return msvcrt.getch()

def output_thread(id, shell):
    size = get_terminal_size()
    shell.resize_pty(width=size[0],height=size[1]) 

    while True:
        if shell.exit_status_ready():
            sys.exit()

        curSize = get_terminal_size()
        if size[0] is not curSize[0] and size[1] is not curSize[1]:
            size = curSize
            shell.resize_pty(width=size[0],height=size[1]) 

        if id is 0:
            output = shell.recv(2048)
            sys.stdout.write(output)
            sys.stdout.flush()
        else:
            output = shell.recv_stderr(2048)
            sys.stderr.write(output)
            sys.stderr.flush()

def input_loop(shell):
    getch = _Getch()

    try:
        while True:
            char = getch()

            if shell.exit_status_ready():
                sys.exit()

            shell.send(char)
    except Exception, e:
        print e
        os._exit(0)


def setup_connection(args):
    hostname = ""
    port = 22
    username = None
    password = None 

    if args.hostname:
        hostname = args.hostname

    if args.port:
        port = args.port 

    if args.username:
        username = args.username 

    if args.password:
        password = args.user_password 


    try:
        sshClient = paramiko.SSHClient()
        sshClient.load_system_host_keys()
        sshClient.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        try:
            sshClient.connect(hostname, port=port, username=username, password=password)  
        except paramiko.ssh_exception.PasswordRequiredException:
            keyPass = ""
            if args.key_passphrase:
                keyPass = args.key_passphrase
            else:
                keyPass = getpass.getpass(prompt='Please input password for private key: ')
            sshClient.connect(hostname, port=port, username=username, password=password, passphrase=keyPass)  


        if args.command:
            stdin, stdout, stderr = sshClient.exec_command(args.command) 

            sys.stdout.write(stdout.read())
            sys.stderr.write(stderr.read())

        if not args.no_shell:
            shell = sshClient.invoke_shell()

            stdout_thread = threading.Thread(target=output_thread, args=(0,shell))
            stderr_thread = threading.Thread(target=output_thread, args=(1,shell))
            
            stdout_thread.start()
            stderr_thread.start()

            input_loop(shell)
    except Exception, e:
        print e
        os._exit(0)

def run():
    parser = argparse.ArgumentParser(description='Minimal Python SSH client arguments (passkeys are automatically imported)')
    parser.add_argument('hostname', type=str, help='Remote SSH server\'s http or ip hostname')
    parser.add_argument('-p', '--port', type=int, help='Remote SSH server\'s port')
    parser.add_argument('-u', '--username', type=str, help='Username used to login to remote SSH server')
    parser.add_argument('-pa', '--password', type=str, help='Password corresponding to provided username')
    parser.add_argument('-kpa', '--key-passphrase', type=str, help='Passphrase for SSH passkey. If needed and not provided, user will be prompted to enter the password')
    parser.add_argument('-c', '--command', type=str, help='Execute provided string as a command over remote connection')
    parser.add_argument('-ns', '--no-shell', action='store_true', help='Specify that no user shell is to be started')
     
    args = parser.parse_args()

    if not args.hostname:
        sys.stdout.write("Must provide the target remote SSH server hostname with -h/--hostname\n")
        parser.print_help()
        sys.exit()

    setup_connection(args)

if __name__ == "__main__":
    run()
