# linux-commands

### CNTLM

cntlm -u USER -d DOMAIN -H

sudo vi /etc/cntlm.conf

### VBOX

sudo mount -t vboxsf -o uid=$UID,gid=$(id -g) Downloads /media/sf_Downloads

### Kill JAVA

ps -ef | grep java | grep -v grep | awk '{print $2}' | xargs -r kill -9

### github proxy

Host github.com
  Hostname ssh.github.com
  Port 443

