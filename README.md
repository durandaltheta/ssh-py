Install on a linux system with './make.sh; sudo ./install.sh'. Otherwise you will need to place contents of this repository in your PATH somewhere (google PATH environment variable for your operating system).

To run via python2.7 in a terminal:

pyssh [hostname]

To run via python3.x in a terminal:

pyssh3 [hostname] 

<br />
<br />
Additionally, if running in a non-bash environment (CMD, PowerShell, etc), 
pyssh and pyssh3 convenience scripts won't work. You will need to create
a script that will function in your environment (a simple .bat file will 
function in any Windows environment while running as administrator).

<br />
<br />
ssh.py and ssh3.py can be compiled into self-contained, bytecode archives using the 'make.sh' bash script ('clean.sh' removes all build files). While not a fully linked binaries, and have to be executed using the python command, they are completely self contained and can be literally copied from one machine to another as a standalone file. These python executable archives are named 'ssh-py' and 'ssh3-py' in the generated 'build/' directory after running 'make.sh'.

<br />
<br />
At a minimum ssh.py and ssh3.py can be invoked (from within their src directory) like any other python script, 
a la:<br />python ssh.py [args] 

OR:<br />python3 ssh3.py [args]

<br />
usage: ssh.py [-h] [-p PORT] [-u USERNAME] [-pa PASSWORD] [-kpa KEY_PASSPHRASE] [-c COMMAND] [-ns] hostname


<br />
<br />
Minimal Python SSH client arguments (passkeys are automatically imported)
<br />
<br />

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

&nbsp;&nbsp;&nbsp;&nbsp;-kpa KEY_PASSPHRASE, --key-passphrase KEY_PASSPHRASE

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Passphrase for SSH passkey. If needed and not provided, user will be prompted to enter the passphrase when needed

&nbsp;&nbsp;&nbsp;&nbsp;-c COMMAND, --command COMMAND

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Execute provided string as a command over remote connection

&nbsp;&nbsp;&nbsp;&nbsp;-ns, --no-shell 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Specify that no user shell is to be started
