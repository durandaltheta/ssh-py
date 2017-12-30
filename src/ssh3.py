import os
import sys
import threading
import paramiko
import argparse
import getpass
import shutil

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
    size = shutil.get_terminal_size()
    shell.resize_pty(width=size.columns,height=size.lines)
    while True:
        if shell.exit_status_ready():
            sys.exit()

        curSize = shutil.get_terminal_size()
        if size.columns is not curSize.columns and size.lines is not curSize.lines:
            size = curSize
            shell.resize_pty(width=size.columns,height=size.lines) 

        if id is 0:
            output = shell.recv(256).decode('utf-8')
            sys.stdout.write(output)
            sys.stdout.flush()
        else:
            output = shell.recv_stderr(256).decode('utf-8')
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
            keyPass = ""
            if args.key_passphrase:
                keyPass = args.key_passphrase
            else:
                keyPass = getpass.getpass(prompt='Please input password for private key: ')
            sshClient.connect(hostname, port=port, username=username, password=password, passphrase=keyPass)  


        if args.command:
            stdin, stdout, stderr = sshClient.exec_command(args.command) 

            sys.stdout.write(stdout.read().decode('utf-8'))
            sys.stderr.write(stderr.read().decode('utf-8'))

        if not args.no_shell:
            shell = sshClient.invoke_shell()

            stdout_thread = threading.Thread(target=output_thread, args=(0,shell))
            stderr_thread = threading.Thread(target=output_thread, args=(1,shell))
            
            stdout_thread.start()
            stderr_thread.start()
            
            input_loop(shell) 
    except Exception as e:
        print(e)
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
