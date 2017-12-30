Install on a linux system with 'sudo ./install.sh'. Otherwise will need to
place contents of this repository in your PATH somewhere (google PATH
environment variable for your operating system)

To run via python2.7:
ssh-py [hostname]

To run via python3.x:
ssh-py3 [hostname]


usage: ssh.py [-h] [-p PORT] [-u USERNAME] [-pa PASSWORD] hostname

Process SSH client arguments

positional arguments:
  hostname              Remote SSH server's http or ip hostname

optional arguments:
  -h, --help            show this help message and exit
  -p PORT, --port PORT  Remote SSH server's port
  -u USERNAME, --username USERNAME
                        Username used to login to remote SSH server
  -pa PASSWORD, --password PASSWORD
                        Password corresponding to provided username

