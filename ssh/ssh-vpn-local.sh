#!/bin/bash
# SSH VPN Installer - Local Version (No wget from autoscript.caliphdev.com)
# Uses files from cloned repository

# Set base directory
BASEDIR="${AUTOSCRIPT_DIR:-/root/autoscript}"

apt dist-upgrade -y
apt install netfilter-persistent -y
apt-get remove --purge ufw firewalld -y
apt install -y screen curl jq bzip2 gzip vnstat coreutils rsyslog iftop zip unzip git apt-transport-https build-essential -y

# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=Indonesia
locality=Jakarta
organization=none
organizationalunit=none
commonname=none
email=none

# simple password minimal
cp "$BASEDIR/ssh/password" /etc/pam.d/common-password
chmod +x /etc/pam.d/common-password

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 0 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 0 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

#install packages
apt -y install jq shc wget curl figlet ruby python make cmake coreutils rsyslog net-tools zip unzip nano sed gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof libsqlite3-dev libz-dev gcc g++ libreadline-dev zlib1g-dev libssl-dev dos2unix

gem install lolcat

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install webserver
apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
cp "$BASEDIR/ssh/nginx.conf" /etc/nginx/nginx.conf
rm /etc/nginx/conf.d/vps.conf
cp "$BASEDIR/ssh/vps.conf" /etc/nginx/conf.d/vps.conf
/etc/init.d/nginx restart

mkdir /etc/systemd/system/nginx.service.d
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
rm /etc/nginx/conf.d/default.conf
systemctl daemon-reload
service nginx restart
cd
mkdir -p /home/vps/public_html
cp "$BASEDIR/ssh/index" /home/vps/public_html/index.html
touch /home/vps/public_html/.htaccess
mkdir /home/vps/public_html/ss-ws
mkdir /home/vps/public_html/clash-ws

# install badvpn
cd
cp "$BASEDIR/ssh/newudpgw" /usr/bin/badvpn-udpgw
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500' /etc/rc.local
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500

# Install Dropbear SSH (alongside OpenSSH)
cd
# Detect OS for compatibility
source /etc/os-release
echo "Detected OS: $ID $VERSION_ID"

# Install dropbear based on OS
case $ID in
    debian|ubuntu)
        apt update
        apt install -y dropbear
        ;;
    *)
        echo "Unsupported OS: $ID"
        exit 1
        ;;
esac

# Keep OpenSSH running on port 22
# Dropbear will use alternative ports

# Configure Dropbear (different ports from OpenSSH)
cat > /etc/default/dropbear <<-END
# Dropbear configuration
NO_START=0
DROPBEAR_PORT="109 143 44"
DROPBEAR_EXTRA_ARGS="-w -g"
DROPBEAR_BANNER="/etc/issue.net"
DROPBEAR_RECEIVE_WINDOW=65536
END

# Enable and start Dropbear
systemctl enable dropbear
systemctl start dropbear
/etc/init.d/dropbear restart

cd
# install stunnel
apt install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 222
connect = 127.0.0.1:22

[dropbear]
accept = 777
connect = 127.0.0.1:109

[ws-stunnel]
accept = 2096
connect = 700

[openvpn]
accept = 442
connect = 127.0.0.1:1194

END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel4
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/lib/systemd/systemd-sysv-install enable stunnel4
systemctl start stunnel4
/etc/init.d/stunnel4 restart


# install fail2ban
apt -y install fail2ban


# // banner /etc/issue.net
cp "$BASEDIR/banner/banner.conf" /etc/issue.net

# blokir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# Copy scripts from local repository
cd /usr/bin

# menu
cp "$BASEDIR/menu/menu.sh" menu
cp "$BASEDIR/menu/m-vmess.sh" m-vmess
cp "$BASEDIR/menu/m-vless.sh" m-vless
cp "$BASEDIR/menu/running.sh" running
cp "$BASEDIR/menu/clearcache.sh" clearcache
cp "$BASEDIR/menu/m-ssws.sh" m-ssws
cp "$BASEDIR/menu/m-trojan.sh" m-trojan
cp "$BASEDIR/xray/xray-renew.sh" xray-renew

# menu ssh ovpn
cp "$BASEDIR/menu/m-sshovpn.sh" m-sshovpn
cp "$BASEDIR/ssh/usernew.sh" usernew
cp "$BASEDIR/ssh/trial.sh" trial
cp "$BASEDIR/ssh/renew.sh" renew
cp "$BASEDIR/ssh/hapus.sh" hapus
cp "$BASEDIR/ssh/cek.sh" cek
cp "$BASEDIR/ssh/member.sh" member
cp "$BASEDIR/ssh/delete.sh" delete
cp "$BASEDIR/ssh/autokill.sh" autokill
cp "$BASEDIR/ssh/ceklim.sh" ceklim
cp "$BASEDIR/ssh/tendang.sh" tendang
cp "$BASEDIR/ssh/user-lock.sh" user-lock
cp "$BASEDIR/ssh/user-unlock.sh" user-unlock

# menu system
cp "$BASEDIR/menu/m-system.sh" m-system
cp "$BASEDIR/menu/m-domain.sh" m-domain
cp "$BASEDIR/ssh/add-host.sh" add-host
cp "$BASEDIR/xray/certv2ray.sh" certv2ray
cp "$BASEDIR/ssh/speedtest_cli.py" speedtest
cp "$BASEDIR/menu/auto-reboot.sh" auto-reboot
cp "$BASEDIR/menu/restart.sh" restart
cp "$BASEDIR/menu/bw.sh" bw
cp "$BASEDIR/menu/tcp.sh" m-tcp
cp "$BASEDIR/ssh/xp.sh" xp
cp "$BASEDIR/menu/m-dns.sh" m-dns

# Menu IPsec
cp "$BASEDIR/menu/m-l2tp.sh" m-l2tp
cp "$BASEDIR/menu/m-sstp.sh" m-sstp
cp "$BASEDIR/menu/m-pptp.sh" m-pptp

# Update script
cp "$BASEDIR/update/update.sh" m-update

chmod +x menu m-vmess m-vless running clearcache m-ssws m-trojan m-pptp m-sstp m-l2tp
chmod +x m-sshovpn usernew trial renew hapus cek member delete autokill ceklim tendang user-lock user-unlock xray-renew
chmod +x m-system m-domain add-host certv2ray speedtest auto-reboot restart bw m-tcp xp m-dns m-update

cd

cat > /etc/cron.d/xp_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 0 * * * root /usr/bin/xp
END

cat > /home/re_otm <<-END
7
END

service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1

# remove unnecessary files
sleep 0.5
apt autoclean -y >/dev/null 2>&1

if dpkg -s unscd >/dev/null 2>&1; then
apt -y remove --purge unscd >/dev/null 2>&1
fi

apt-get -y --purge remove samba* >/dev/null 2>&1
apt-get -y --purge remove apache2* >/dev/null 2>&1
apt-get -y --purge remove bind9* >/dev/null 2>&1
apt-get -y remove sendmail* >/dev/null 2>&1
apt autoremove -y >/dev/null 2>&1

# finishing
cd
chown -R www-data:www-data /home/vps/public_html
sleep 0.5
echo -e "Restart All service SSH"
/etc/init.d/nginx restart >/dev/null 2>&1
sleep 0.5
/etc/init.d/openvpn restart >/dev/null 2>&1
sleep 0.5
/etc/init.d/dropbear restart >/dev/null 2>&1
sleep 0.5
/etc/init.d/stunnel4 restart >/dev/null 2>&1
sleep 0.5
/etc/init.d/vnstat restart >/dev/null 2>&1
sleep 0.5
/etc/init.d/squid restart >/dev/null 2>&1

screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500


rm -f /root/key.pem
rm -f /root/cert.pem

# finihsing
clear
echo "SSH/Dropbear installation complete!"
