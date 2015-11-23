# linux-commands

### CNTLM

cntlm -u USER -d DOMAIN -H

sudo vi /etc/cntlm.conf

### VBOX

sudo mount -t vboxsf -o uid=$UID,gid=$(id -g) Downloads /media/sf_Downloads

VBoxManage modifyvm VMNAME --natdnshostresolver1 on

### Kill JAVA

ps -ef | grep java | grep -v grep | awk '{print $2}' | xargs -r kill -9

### github proxy

```
host github.com
    user git
    hostname github.com
    port 22
    proxycommand socat - PROXY:localhost:%h:%p,proxyport=3128,proxyauth=:
```
