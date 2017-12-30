import os
import sys
import threading
import time
import paramiko
import argparse
import getpass

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
    while True:
        if shell.exit_status_ready():
            sys.exit()

        if id is 0:
            if shell.recv_ready():
                output = shell.recv(256).decode('utf-8')
                sys.stdout.write(output)
                sys.stdout.flush()
            else:
                time.sleep(0.01)
        else:
            if shell.recv_stderr_ready():
                output = shell.recv_stderr(256).decode('utf-8')
                sys.stderr.write(output)
                sys.stderr.flush()
            else:
                time.sleep(0.01)

def input_loop(shell):
    getch = _Getch()

    try:
        while True:
            char = getch()

            if shell.exit_status_ready():
                sys.exit()

            while not shell.send_ready():
                time.sleep(0.01)

            shell.send(char)
    except Exception as e:
        print(e)
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
            keyPass = getpass.getpass(prompt='Please input password for private key: ')
            sshClient.connect(hostname, port=port, username=username, password=password, passphrase=keyPass)  


        shell = sshClient.invoke_shell()
        shell.setblocking(0)

        stdout_thread = threading.Thread(target=output_thread, args=(0,shell))
        stderr_thread = threading.Thread(target=output_thread, args=(1,shell))
        
        stdout_thread.start()
        stderr_thread.start()

        input_loop(shell)
    except Exception as e:
        print(e)
        os._exit(0)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Minimal Python SSH client arguments (passkeys are automatically imported)')
    parser.add_argument('hostname', type=str, help='Remote SSH server\'s http or ip hostname')
    parser.add_argument('-p', '--port', type=int, help='Remote SSH server\'s port')
    parser.add_argument('-u', '--username', type=str, help='Username used to login to remote SSH server')
    parser.add_argument('-pa', '--password', type=str, help='Password corresponding to provided username')
     
    args = parser.parse_args()

    if not args.hostname:
        sys.stdout.write("Must provide the target remote SSH server hostname with -h/--hostname\n")
        parser.print_help()
        sys.exit()

    setup_connection(args)
