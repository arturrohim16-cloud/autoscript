#!/bin/bash
# AutoScript VPN Installer - Git Clone Version
# Tidak memerlukan autoscript.caliphdev.com

# Colors
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'
BBlue='\e[1;34m'
BGreen='\e[1;32m'
BRed='\e[1;31m'
BYellow='\e[1;33m'

clear
echo -e "${BBlue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BGreen}    AutoScript VPN Installer (Local)     ${NC}"
echo -e "${BBlue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check root
if [ "${EUID}" -ne 0 ]; then
    echo -e "${BRed}You need to run this script as root${NC}"
    exit 1
fi

# Check virtualization
if [ "$(systemd-detect-virt)" == "openvz" ]; then
    echo -e "${BRed}OpenVZ is not supported${NC}"
    exit 1
fi

# Install required packages
echo -e "[ ${BGreen}INFO${NC} ] Installing required packages..."
apt update -y
apt install -y git curl wget

# Set variables
INSTALL_DIR="/root/autoscript"

# Make scripts executable
find . -name "*.sh" -exec chmod +x {} \;

# Set BASE_DIR for other scripts to use
export AUTOSCRIPT_DIR="$INSTALL_DIR"

# Setup hosts
localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
    echo "$localip $(hostname)" >> /etc/hosts
fi

# Create directories
mkdir -p /etc/xray
mkdir -p /etc/v2ray
touch /etc/xray/domain
touch /etc/v2ray/domain
touch /etc/xray/scdomain
touch /etc/v2ray/scdomain

# Check headers
echo -e "[ ${BGreen}INFO${NC} ] Checking kernel headers..."
totet=`uname -r`
REQUIRED_PKG="linux-headers-$totet"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG 2>/dev/null | grep "install ok installed")
if [ "" = "$PKG_OK" ]; then
    echo -e "[ ${BYellow}WARNING${NC} ] Installing $REQUIRED_PKG..."
    apt-get --yes install $REQUIRED_PKG
fi

# Domain setup
echo ""
echo -e "${BBlue}                SETUP DOMAIN VPS     ${NC}"
echo -e "${BYellow}----------------------------------------------------------${NC}"
echo -e "${BGreen} 1. Use Domain Random / Gunakan Domain Random ${NC}"
echo -e "${BGreen} 2. Choose Your Own Domain / Gunakan Domain Sendiri ${NC}"
echo -e "${BYellow}----------------------------------------------------------${NC}"
read -rp " Input 1 or 2: " dns

mkdir -p /var/lib/
echo "IP=" >> /var/lib/ipvps.conf

if [ "$dns" == "1" ]; then
    # Domain random - run cf.sh
    chmod +x "$INSTALL_DIR/ssh/cf.sh"
    bash "$INSTALL_DIR/ssh/cf.sh"
elif [ "$dns" == "2" ]; then
    read -rp "Enter Your Domain: " dom
    echo "IP=$dom" > /var/lib/ipvps.conf
    echo "$dom" > /root/scdomain
    echo "$dom" > /etc/xray/scdomain
    echo "$dom" > /etc/xray/domain
    echo "$dom" > /etc/v2ray/domain
    echo "$dom" > /root/domain
else 
    echo "Invalid option"
    exit 1
fi

echo -e "${BGreen}Domain setup complete!${NC}"
sleep 2
clear

# Install golang
echo -e "[ ${BGreen}INFO${NC} ] Installing Golang..."
curl -s https://go.dev/VERSION?m=text | head -n 1 | \
    xargs -I {} wget -q https://go.dev/dl/{}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go*.linux-amd64.tar.gz && \
    rm go*.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

# Run SSH VPN installer
echo -e "[ ${BGreen}INFO${NC} ] Installing SSH/Dropbear..."
chmod +x "$INSTALL_DIR/ssh/ssh-vpn-local.sh"
bash "$INSTALL_DIR/ssh/ssh-vpn-local.sh"

# Run XRAY installer
echo -e "[ ${BGreen}INFO${NC} ] Installing XRAY..."
chmod +x "$INSTALL_DIR/xray/ins-xray-local.sh"
bash "$INSTALL_DIR/xray/ins-xray-local.sh"

# Run SSH WS installer
echo -e "[ ${BGreen}INFO${NC} ] Installing SSH Websocket..."
chmod +x "$INSTALL_DIR/sshws/insshws-local.sh"
bash "$INSTALL_DIR/sshws/insshws-local.sh"

# Setup profile
cat> /root/.profile <<END
if [ "\$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi
mesg n || true
menu
END
chmod 644 /root/.profile

# Create log files
[ ! -f "/etc/log-create-ssh.log" ] && echo "Log SSH Account " > /etc/log-create-ssh.log
[ ! -f "/etc/log-create-vmess.log" ] && echo "Log Vmess Account " > /etc/log-create-vmess.log
[ ! -f "/etc/log-create-vless.log" ] && echo "Log Vless Account " > /etc/log-create-vless.log
[ ! -f "/etc/log-create-trojan.log" ] && echo "Log Trojan Account " > /etc/log-create-trojan.log
[ ! -f "/etc/log-create-shadowsocks.log" ] && echo "Log Shadowsocks Account " > /etc/log-create-shadowsocks.log

# Get IP
curl -sS http://checkip.amazonaws.com/ > /etc/myipvps

# Print info
echo ""
echo "=================================================================="
echo "      ___                                    ___         ___      "
echo "     /  /\        ___           ___         /  /\       /__/\     "
echo "    /  /:/_      /  /\         /__/\       /  /::\      \  \:\    "
echo "   /  /:/ /\    /  /:/         \  \:\     /  /:/\:\      \  \:\   "
echo "  /  /:/_/::\  /__/::\          \  \:\   /  /:/~/:/  _____\__\:\  "
echo " /__/:/__\/\:\ \__\/\:\__   ___  \__\:\ /__/:/ /:/  /__/::::::::\ "
echo " \  \:\ /~~/:/    \  \:\/\ /__/\ |  |:| \  \:\/:/   \  \:\~~\~~\/ "
echo "  \  \:\  /:/      \__\::/ \  \:\|  |:|  \  \::/     \  \:\  ~~~  "
echo "   \  \:\/:/       /__/:/   \  \:\__|:|   \  \:\      \  \:\      "
echo "    \  \::/        \__\/     \__\::::/     \  \:\      \  \:\     "
echo "     \__\/                       ~~~~       \__\/       \__\/ 1.0 "
echo "=================================================================="
echo ""
echo "   >>> Service & Port"
echo "   - OpenSSH                  : 22"
echo "   - Dropbear                 : 109, 143, 44"
echo "   - SSH Websocket            : 80"
echo "   - SSH SSL Websocket        : 443"
echo "   - Stunnel4                 : 222, 777"
echo "   - Badvpn                   : 7100-7900"
echo "   - Nginx                    : 81"
echo "   - Vmess WS TLS             : 443"
echo "   - Vless WS TLS             : 443"
echo "   - Trojan WS TLS            : 443"
echo "   - Shadowsocks WS TLS       : 443"
echo ""
echo "=============================Contact=============================="
echo "--------------------------t.me/caliphdev--------------------------"
echo "=================================================================="
echo ""
echo "Installation complete!"
echo ""

# Countdown to reboot
for i in {10..1}; do
    echo -ne "\rAuto reboot in $i seconds "
    sleep 1
done
echo -e "\nRebooting..."
reboot
