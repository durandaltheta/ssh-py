Install on a linux system with 'sudo ./install.sh'. Otherwise you will need to place contents of this repository in your PATH somewhere (google PATH environment variable for your operating system)

To run via python2.7:
ssh-py [hostname]

To run via python3.x:
ssh-py3 [hostname] 

Additionally, if running in a non-bash environment (CMD, PowerShell, etc), 
ssh-py and ssh-py3 convenience scripts won't work. You will need to create
a script that will function in your environment (a simple .bat file will 
function in any Windows environment while running as administrator).

At a minimum ssh.py and ssh3.py can be invoked like any other python script, 
a la:<br />python ssh-py [args] 

OR:<br />python3 ssh-py3 [args]

<br />
usage: ssh.py [-h] [-p PORT] [-u USERNAME] [-pa PASSWORD] hostname

Minimal Python SSH client arguments (passkeys are automatically imported)

positional arguments:

&nbsp;&nbsp;&nbsp;&nbsp;hostname&nbsp;&nbsp;&nbsp;&nbsp;Remote SSH server's http or ip hostname

optional arguments:

&nbsp;&nbsp;&nbsp;&nbsp;-h, --help 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;show this help message and exit 

&nbsp;&nbsp;&nbsp;&nbsp;-p PORT, --port PORT 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Remote SSH server's port 

&nbsp;&nbsp;&nbsp;&nbsp;-u USERNAME, --username USERNAME 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Username used to login to remote SSH server 

&nbsp;&nbsp;&nbsp;&nbsp;-pa PASSWORD, --password PASSWORD 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Password corresponding to provided username

