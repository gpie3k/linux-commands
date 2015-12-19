#!/usr/bin/env bash

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

confirm () {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure?} [Y/n] " response
    case $response in
        [yY][eE][sS]|[yY]|'')
            true
            ;;
        *)
            false
            ;;
    esac
}

DOMAIN=GLOBAL
PROXY=
NO_PROXY="localhost, 127.0.0.*, 10.*, 192.168.*"
LOG_NAME=$(logname)
PROXIES=

while true;
do
  case "$1" in
    --user ) SG_USER="$2"; shift 2 ;;
    --password ) SG_PASSWORD="$2"; shift 2 ;;
    --proxy ) PROXY="$2"; shift 2 ;;
    --domain ) DOMAIN="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

if [ -z "${SG_USER}" ]; then
    read -p "User: " SG_USER
fi

if [ -z "${SG_PASSWORD}" ]; then
    read -s -p "Password: " SG_PASSWORD
fi

if [ -z "${PROXY}" ]; then
    read -p "Proxy: " PROXY
fi

if [ -z "${PROXIES}" ]; then
    PROXIES="Proxy ${PROXY}"
fi

export http_proxy=http://${SG_USER}:${SG_PASSWORD}@${PROXY}/
export https_proxy=http://${SG_USER}:${SG_PASSWORD}@${PROXY}/

wget -O - www.google.com > /dev/null
if [ $? -ne 0 ]; then
    echo Cannot connect to www.goggle.com. Exiting ...
    exit 300
fi

CNTLM_STATUS=$(dpkg-query -W -f='${Status}' cntlm)
if [ ! "${CNTLM_STATUS}" == "install ok installed" ]; then
    echo Installing Tools ...
    apt-get update
    apt-get install -y build-essential alacarte git subversion cntlm vim mc terminator
else
    echo Tools already installed
fi

grep -q "${SG_USER}" /etc/cntlm.conf
if [ ! $? -eq 0 ]; then
echo Setting up CNTLM ....

CNTLM_PASS=$(echo ${SG_PASSWORD} | cntlm -u ${SG_USER} -d ${DOMAIN} -H | grep -v Password:)

cat << EOF > /etc/cntlm.conf
#
# Cntlm Authentication Proxy Configuration
#
# NOTE: all values are parsed literally, do NOT escape spaces,
# do not quote. Use 0600 perms if you use plaintext password.
#

Username        ${SG_USER}
Domain          GLOBAL

# NOTE: Use plaintext password only at your own risk
# Use hashes instead. You can use a "cntlm -M" and "cntlm -H"
# command sequence to get the right config for your environment.
# See cntlm man page
${CNTLM_PASS}

# Specify the netbios hostname cntlm will send to the parent
# proxies. Normally the value is auto-guessed.
#
# Workstation   netbios_hostname

# List of parent proxies to use. More proxies can be defined
# one per line in format <proxy_ip>:<proxy_port>
#
${PROXIES}

# List addresses you do not want to pass to parent proxies
# * and ? wildcards can be used
#
NoProxy         ${NO_PROXY}

# Specify the port cntlm will listen on
# You can bind cntlm to specific interface by specifying
# the appropriate IP address also in format <local_ip>:<local_port>
# Cntlm listens on 127.0.0.1:3128 by default
#
Listen          3128

# If you wish to use the SOCKS5 proxy feature as well, uncomment
# the following option. It can be used several times
# to have SOCKS5 on more than one port or on different network
# interfaces (specify explicit source address for that).
#
# WARNING: The service accepts all requests, unless you use
# SOCKS5User and make authentication mandatory. SOCKS5User
# can be used repeatedly for a whole bunch of individual accounts.
#
#SOCKS5Proxy    8010
#SOCKS5User     dave:password

# Use -M first to detect the best NTLM settings for your proxy.
# Default is to use the only secure hash, NTLMv2, but it is not
# as available as the older stuff.
#
# This example is the most universal setup known to man, but it
# uses the weakest hash ever. I won't have it's usage on my
# conscience. :) Really, try -M first.
#
Auth            NTLM
#Flags          0x06820000

# Enable to allow access from other computers
#
#Gateway        yes

# Useful in Gateway mode to allow/restrict certain IPs
# Specifiy individual IPs or subnets one rule per line.
#
#Allow          127.0.0.1
#Deny           0/0

# GFI WebMonitor-handling plugin parameters, disabled by default
#
#ISAScannerSize     1024
#ISAScannerAgent    Wget/
#ISAScannerAgent    APT-HTTP/
#ISAScannerAgent    Yum/

# Headers which should be replaced if present in the request
#
#Header         User-Agent: Mozilla/4.0 (compatible; MSIE 5.5; Windows 98)

# Tunnels mapping local port to a machine behind the proxy.
# The format is <local_port>:<remote_host>:<remote_port>
#
#Tunnel         11443:remote.com:443
EOF

invoke-rc.d cntlm restart
else
    echo CNTLM already set
fi


APT_FILE=/etc/apt/apt.conf
grep -q "http://127.0.0.1:3128/" ${APT_FILE}
if [ ! $? -eq 0 ]; then
echo Setting proxy for ${APT_FILE}
cat << EOF > ${APT_FILE}
Acquire::http::proxy "http://127.0.0.1:3128/";
Acquire::https::proxy "http://127.0.0.1:3128/";
Acquire::ftp::proxy "http://127.0.0.1:3128/";
Acquire::socks::proxy "http://127.0.0.1:3128/";
EOF
else
    echo APT Proxy already set
fi

ENV_FILE=/etc/environment
grep -q "http://127.0.0.1:3128/" ${ENV_FILE}
if [ ! $? -eq 0 ]; then
echo Setting Proxy for ${ENV_FILE}
cat << EOF >> ${ENV_FILE}

http_proxy="http://127.0.0.1:3128/"
https_proxy="http://127.0.0.1:3128/"
ftp_proxy="http://127.0.0.1:3128/"
socks_proxy="http://127.0.0.1:3128/"
no_proxy="localhost,127.0.0.1"

HTTP_PROXY="http://127.0.0.1:3128/"
HTTPS_PROXY="http://127.0.0.1:3128/"
FTP_PROXY="http://127.0.0.1:3128/"
NO_PROXY="localhost,127.0.0.1"
EOF
else
    echo ENV Proxy already set
fi

usermod -a -G vboxsf ${LOG_NAME}

confirm 'Reboot?' && reboot
