#!/bin/bash

cekray=`cat /root/log-install.txt | grep -ow "XRAY" | sort | uniq`
if [ "$cekray" = "XRAY" ]; then
domen=`cat /etc/xray/domain`
else
domen=`cat /etc/v2ray/domain`
fi
portsshws=`cat ~/log-install.txt | grep -w "SSH Websocket" | cut -d: -f2 | awk '{print $1}'`
wsssl=`cat /root/log-install.txt | grep -w "SSH SSL Websocket" | cut -d: -f2 | awk '{print $1}'`

echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;41;36m            SSH Account            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (hari): " masaaktif

IP=$(curl -sS ifconfig.me);
ossl=`cat /root/log-install.txt | grep -w "OpenVPN" | cut -f2 -d: | awk '{print $6}'`
opensh=`cat /root/log-install.txt | grep -w "OpenSSH" | cut -f2 -d: | awk '{print $1}'`
ssl="$(cat ~/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"

OhpSSH=`cat /root/log-install.txt | grep -w "OHP SSH" | cut -d: -f2 | awk '{print $1}'`
OhpDB=`cat /root/log-install.txt | grep -w "OHP DBear" | cut -d: -f2 | awk '{print $1}'`
OhpOVPN=`cat /root/log-install.txt | grep -w "OHP OpenVPN" | cut -d: -f2 | awk '{print $1}'`

sleep 1
clear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
PID=`ps -ef |grep -v grep | grep sshws |awk '{print $2}'`

source /usr/bin/bot.sh
msg="🚀 <b>SSH ACCOUNT CREATED</b> 🚀
━━━━━━━━━━━━━━━━━━━━━
👤 <b>User:</b> <code>$Login</code>
🔑 <b>Pass:</b> <code>$Pass</code>
📅 <b>Exp:</b> <code>$exp</code>
━━━━━━━━━━━━━━━━━━━━━
🌐 <b>IP Address :</b> <code>$IP</code>
✨ <b>Host : </b> <code>$domen</code>
🔓 <b>OpenSSH :</b> <code>22</code>
🐻 <b>Dropbear :</b> <code>109, 143</code>
🔐 <b>SSH-WS :</b> <code>80</code>
🔌 <b>SSH-SSL-WS :</b> <code>443</code>
🚀 <b>UDPGW :</b> <code>7100-7300</code>
━━━━━━━━━━━━━━━━━━━━━━
📝 <b>Payload Websocket :</b>
<code>GET / [protocol][crlf]Host: [host][crlf]Connection: Keep-Alive[crlf]Connection: Upgrade[crlf]Upgrade: websocket[crlf][crlf]</code>
━━━━━━━━━━━━━━━━━━━━━━
🔗 <b>Format Login (Klik untuk Salin) :</b>
🔹 <b>SSH-SSL :</b> 
<code>$domen:443@$Login:$Pass</code>
🔹 <b>SSH-NONSL-WS :</b> 
<code>$domen:80@$Login:$Pass</code>
🔹 <b>UDP Custom :</b> 
<code>$domen:1-65535@$Login:$Pass</code>
━━━━━━━━━━━━━━━━━━━━━━
✅ <b>Script By AJI VPN</b>"

send_log "$msg"

if [[ ! -z "${PID}" ]]; then
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "\E[0;41;36m            SSH Account            \E[0m" | tee -a /etc/log-create-ssh.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "Username    : $Login" | tee -a /etc/log-create-ssh.log
echo -e "Password    : $Pass" | tee -a /etc/log-create-ssh.log
echo -e "Expired On  : $exp" | tee -a /etc/log-create-ssh.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "IP          : $IP" | tee -a /etc/log-create-ssh.log
echo -e "Host        : $domen" | tee -a /etc/log-create-ssh.log
echo -e "OpenSSH     : $opensh" | tee -a /etc/log-create-ssh.log
echo -e "SSH WS      : $portsshws" | tee -a /etc/log-create-ssh.log
echo -e "SSH SSL WS  : $wsssl" | tee -a /etc/log-create-ssh.log
echo -e "SSL/TLS     :$ssl" | tee -a /etc/log-create-ssh.log
echo -e "UDPGW       : 7100-7900" | tee -a /etc/log-create-ssh.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "Payload WSS" | tee -a /etc/log-create-ssh.log
echo -e "
GET wss://isi_bug_disini HTTP/1.1[crlf]Host: ${domen}[crlf]Upgrade: websocket[crlf][crlf]
" | tee -a /etc/log-create-ssh.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "<code>$domen:443@$Login:$Pass</code>🔹 <b>SSH-NONSL-WS :</b>" 
echo -e "<code>$domen:80@$Login:$Pass</code>🔹 <b>UDP Custom :</b>"
echo -e "<code>$domen:1-65535@$Login:$Pass</code>"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
else

echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "\E[0;41;36m            SSH Account            \E[0m" | tee -a /etc/log-create-ssh.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "Username    : $Login" | tee -a /etc/log-create-ssh.log
echo -e "Password    : $Pass" | tee -a /etc/log-create-ssh.log
echo -e "Expired On  : $exp" | tee -a /etc/log-create-ssh.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "IP          : $IP" | tee -a /etc/log-create-ssh.log
echo -e "Host        : $domen" | tee -a /etc/log-create-ssh.log
echo -e "OpenSSH     : $opensh" | tee -a /etc/log-create-ssh.log
echo -e "SSH WS      : $portsshws" | tee -a /etc/log-create-ssh.log
echo -e "SSH SSL WS  : $wsssl" | tee -a /etc/log-create-ssh.log
echo -e "SSL/TLS     :$ssl" | tee -a /etc/log-create-ssh.log
echo -e "UDPGW       : 7100-7900" | tee -a /etc/log-create-ssh.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "Expired On     : $exp" | tee -a /etc/log-create-ssh.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "Payload WSS" | tee -a /etc/log-create-ssh.log
echo -e "
GET wss://isi_bug_disini HTTP/1.1[crlf]Host: ${domen}[crlf]Upgrade: websocket[crlf][crlf]
" | tee -a /etc/log-create-ssh.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
echo -e "Payload WS" | tee -a /etc/log-create-ssh.log
echo -e "
GET / HTTP/1.1[crlf]Host: $domen[crlf]Upgrade: websocket[crlf][crlf]
" | tee -a /etc/log-create-ssh.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-ssh.log
fi
echo "" | tee -a /etc/log-create-ssh.log
read -n 1 -s -r -p "Press any key to back on menu"
m-sshovpn
