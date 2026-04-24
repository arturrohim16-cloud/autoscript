#!/bin/bash
#warna
CYAN='\e[1;36m'
GREEN='\e[1;32m'
NC='\e[0m'

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
echo -e ""
read -p "Masukan Limit Login (IP): " iplimit
# Jika input kosong, default set ke 1
if [ -z "$iplimit" ]; then iplimit="1"; fi
echo "$Login $iplimit" >> /etc/ssh/limit.db
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
loading() {
    local duration=20
    echo -ne "${CYAN}Progress : [${NC}"
    for ((i=1; i<=duration; i++)); do
        # Menghitung persentase berdasarkan jumlah blok
        # $i dikali 5 karena 20 blok x 5 = 100%
        percent=$(( i * 5 ))
        
        echo -ne "${GREEN}█${NC}"
        
        # Simpan posisi kursor, cetak persen di luar bracket, lalu kembalikan kursor
        echo -ne "${CYAN}] ${percent}%${NC}"
        
        # Backspace untuk menghapus tulisan persen agar bisa ditimpa blok berikutnya
        if [ $i -lt $duration ]; then
            echo -ne "\b\b\b\b\b"
        fi
        
        sleep 0.1
    done
    echo -ne "\n"
    sleep 0.5
}
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
clear
loading
PID=`ps -ef |grep -v grep | grep sshws |awk '{print $2}'`
#kirim notifikasi tele
# Bot configuration
KEY=$(grep -E "^#bot# " "/etc/bot/.bot.db" 2>/dev/null | head -n1 | cut -d ' ' -f 2 || echo "")
CHATIDS=$(grep -E "^#bot# " "/etc/bot/.bot.db" 2>/dev/null | cut -d ' ' -f 3 || echo "")
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="🚀 <b>SSH ACCOUNT CREATED</b> 🚀
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

if [[ -n "$KEY" && -n "$CHATIDS" ]]; then
    for CHATID in $CHATIDS; do
        curl -s --max-time "$TIME" \
            -d "chat_id=$CHATID" \
            -d "disable_web_page_preview=1" \
            --data-urlencode "text=$TEXT" \
            -d "parse_mode=html" \
            "$URL" >/dev/null
    done
fi
    
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
