Install on a linux system with 'sudo ./install.sh'. Otherwise will need to
place contents of this repository in your PATH somewhere (google PATH
environment variable for your operating system)

To run via python2.7:
ssh-py [hostname]

To run via python3.x:
ssh-py3 [hostname]


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

