# linux-commands

### CNTLM

```
cntlm -u USER -d DOMAIN -H

sudo vi /etc/cntlm.conf
```

### VBOX
```
sudo mount -t vboxsf -o uid=$UID,gid=$(id -g) Downloads /media/sf_Downloads
```

```
wmic diskdrive list brief 

VBoxManage internalcommands createrawvmdk -filename c:\Users\sg0897499\.VirtualBox\PLEXTOR.vmdk -rawdisk \\.\PHYSICALDRIVE1

VBoxManage modifyvm "Ubuntu" --natdnshostresolver1 on
```

### PROMPT

```
export PS1="\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n$"
```

### Kill JAVA

```
ps -ef | grep java | grep -v grep | awk '{print $2}' | xargs -r kill -9
```

### no strict host checking

```
Host localhost
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null

Host 127.0.0.1
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
```

### github proxy

```
host github.com
    user git
    hostname github.com
    port 22
    proxycommand socat - PROXY:localhost:%h:%p,proxyport=3128,proxyauth=:
```
