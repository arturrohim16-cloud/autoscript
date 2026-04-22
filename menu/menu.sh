#!/bin/bash
MYIP=$(curl -sS ifconfig.me)
echo "Checking VPS"
# Color Validation
DF='\e[39m'
Bold='\e[1m'
Blink='\e[5m'
yell='\e[33m'
red='\e[31m'
green='\e[32m'
blue='\e[34m'
PURPLE='\e[35m'
cyan='\e[36m'
Lred='\e[91m'
Lgreen='\e[92m'
Lyellow='\e[93m'
BGreen='\e[1;32m'
BYellow='\e[1;33m'
BBlue='\e[1;34m'
BPurple='\e[1;35m'
BCyan='\e[1;36m'
NC='\e[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
LIGHT='\033[0;37m'
# VPS Information
#Domain
domain=$(cat /etc/xray/domain)
#Status certificate
modifyTime=$(stat $HOME/.acme.sh/${domain}_ecc/${domain}.key | sed -n '7,6p' | awk '{print $2" "$3" "$4" "$5}')
modifyTime1=$(date +%s -d "${modifyTime}")
currentTime=$(date +%s)
stampDiff=$(expr ${currentTime} - ${modifyTime1})
days=$(expr ${stampDiff} / 86400)
remainingDays=$(expr 90 - ${days})
tlsStatus=${remainingDays}
if [[ ${remainingDays} -le 0 ]]; then
	tlsStatus="expired"
fi
# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"
# Cek Status XRAY
if systemctl is-active --quiet xray; then
    status_xray="${GREEN}ON${NC}"
else
    status_xray="${RED}OFF${NC}"
fi

# Cek Status NGINX
if systemctl is-active --quiet nginx; then
    status_nginx="${GREEN}ON${NC}"
else
    status_nginx="${RED}OFF${NC}"
fi

# Cek Status SSH-WS (Sesuaikan nama servicenya, misal: ws-stunnel atau ssh-ws)
if systemctl is-active --quiet ws-stunnel; then
    status_ssh="${GREEN}ON${NC}"
else
    status_ssh="${RED}OFF${NC}"
fi
#totsl akun ssh/xray
vmess=$(grep -c -E "^#vmsg $user" "/etc/xray/config.json")
vless=$(grep -c -E "^#vlsg $user" "/etc/xray/config.json")
tr=$(grep -c -E "^#trg $user" "/etc/xray/config.json")
ss=$(grep -c -E "^#ssg $user" "/etc/xray/config.json")
ssh="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
# Download
#Download/Upload today
dtoday="$(vnstat -i ens3 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
utoday="$(vnstat -i ens3 | grep "today" | awk '{print $5" "substr ($6, 1, 1)}')"
ttoday="$(vnstat -i ens3 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload yesterday
dyest="$(vnstat -i ens3 | grep "yesterday" | awk '{print $2" "substr ($3, 1, 1)}')"
uyest="$(vnstat -i ens3 | grep "yesterday" | awk '{print $5" "substr ($6, 1, 1)}')"
tyest="$(vnstat -i ens3 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload current month
dmon="$(vnstat -i ens3 -m | grep "`date +"%b '%y"`" | awk '{print $3" "substr ($4, 1, 1)}')"
umon="$(vnstat -i ens3 -m | grep "`date +"%b '%y"`" | awk '{print $6" "substr ($7, 1, 1)}')"
tmon="$(vnstat -i ens3 -m | grep "`date +"%b '%y"`" | awk '{print $9" "substr ($10, 1, 1)}')"
# user
Exp2=$"unlimited"
Name=$"AJIVPN"
# Getting CPU Information
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${corediilik:-1}))"
cpu_usage+=" %"
ISP=$(curl -s ipinfo.io/org?token=ce3da57536810d | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city?token=ce3da57536810d )
#WKT=$(curl -s ipinfo.io/timezone?token=ce3da57536810d )
DAY=$(date +%A)
DATE=$(date +%m/%d/%Y)
DATE2=$(date -R | cut -d " " -f -5)
IPVPS=$(curl -s ifconfig.me )
LOC=$(curl -s ifconfig.co/country )
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
uram=$( free -m | awk 'NR==2 {print $3}' )
fram=$( free -m | awk 'NR==2 {print $4}' )
clear 
# --- WARNA (Lengkap) ---
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
GREEN='\e[1;32m'
RED='\e[1;31m'
BLUE='\e[1;34m'
PURPLE='\e[1;35m'
BG_RED='\e[41;1;37m'
NC='\e[0m'

# --- LOGIKA STATUS & TRAFFIC ---
status_xray=$(systemctl is-active xray &>/dev/null && echo -e "${GREEN}ON${NC}" || echo -e "${RED}OFF${NC}")
status_nginx=$(systemctl is-active nginx &>/dev/null && echo -e "${GREEN}ON${NC}" || echo -e "${RED}OFF${NC}")
status_ssh=$(systemctl is-active ws-stunnel &>/dev/null && echo -e "${GREEN}ON${NC}" || echo -e "${RED}OFF${NC}")

# --- DASHBOARD START ---
clear
echo -e "${CYAN}┌─────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC}      ${YELLOW}⁙⁙⁙⁙⁙⁙⁙${NC} ${BG_RED} AJI SYSTEM PREMIUM ${NC} ${YELLOW}⁙⁙⁙⁙⁙⁙⁙${NC}       ${CYAN}│${NC}"
echo -e "${CYAN}└─────────────────────────────────────────────────┘${NC}"

# Bagian Informasi System
echo -e "${CYAN}┌─────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC} ${YELLOW}SYSTEM OS      ${NC}: ${WHITE}$(hostnamectl | grep "Operating System" | cut -d ' ' -f5-) ${NC}"
echo -e "${CYAN}│${NC} ${YELLOW}CPU            ${NC}: ${WHITE}AuthenticAMD 1 CORE${NC}"
echo -e "${CYAN}│${NC} ${YELLOW}SERVER RAM     ${NC}: ${WHITE}$uram/$tram MB${NC}"
echo -e "${CYAN}│${NC} ${YELLOW}UPTIME SERVER  ${NC}: ${WHITE}$uptime${NC}"
echo -e "${CYAN}│${NC} ${YELLOW}IP VPS         ${NC}: ${WHITE}$IPVPS${NC}"
echo -e "${CYAN}│${NC} ${YELLOW}DOMAIN         ${NC}: ${WHITE}$domain${NC}"
echo -e "${CYAN}├─────────────────────────────────────────────────┤${NC}"
# Bagian Penggunaan Kuota (Traffic)
echo -e "${CYAN}│${NC} ${GREEN}DOWNLOAD       ${NC}: ${WHITE}$dtoday${NC}  ${WB}[${GB}${ssh}${WB}]${NC}"
echo -e "${CYAN}│${NC} ${GREEN}UPLOAD         ${NC}: ${WHITE}$utoday${NC}  ${WB}[${GB}${vmess}${WB}]${NC}"
echo -e "${CYAN}│${NC} ${GREEN}TOTAL TRAFFIC  ${NC}: ${WHITE}$ttoday${NC}  ${WB}[${GB}${vless}${WB}]${NC}"
echo -e "${CYAN}└─────────────────────────────────────────────────┘${NC}"

# Bagian Status Service
echo -e "${CYAN}┌─────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC}    ${YELLOW}PROXY :${NC} $status_ssh ${CYAN}|${NC} ${YELLOW}NGINX :${NC} $status_nginx ${CYAN}|${NC} ${YELLOW}XRAY :${NC} $status_xray ${CYAN}|${NC} ${GREEN} GOOD ${NC} ${CYAN}│${NC}"
echo -e "${CYAN}└─────────────────────────────────────────────────┘${NC}"

# Bagian License Box
echo -e "   ${CYAN}┌───────────────────────────────────────────┐${NC}"
echo -e "   ${CYAN}│${NC} ${YELLOW}VERSION    ${NC}: ${WHITE}v15.2.7 D£VSX-NETWORK${NC}        ${CYAN}│${NC}"
echo -e "   ${CYAN}│${NC} ${YELLOW}STATUS     ${NC}: ${GREEN}(active)${NC}                     ${CYAN}│${NC}"
echo -e "   ${CYAN}│${NC} ${YELLOW}CLIENTS    ${NC}: ${PURPLE}$Name${NC}                       ${CYAN}│${NC}"
echo -e "   ${CYAN}│${NC} ${YELLOW}EXPIRY     ${NC}: ${WHITE}$Exp2${NC}                    ${CYAN}│${NC}"
echo -e "   ${CYAN}└───────────────────────────────────────────┘${NC}"

# Bagian Menu (2 Kolom)
echo -e "${CYAN}┌─────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC}  ${YELLOW}1.)☞${NC} ${WHITE}SSH/OPENVPN${NC}         ${YELLOW}8.)☞${NC} ${WHITE}BOT TELEGRAM${NC}     ${CYAN}│${NC}"
echo -e "${CYAN}│${NC}  ${YELLOW}2.)☞${NC} ${WHITE}MENU VMESS${NC}          ${YELLOW}9.)☞${NC} ${WHITE}UPDATE SCRIPT${NC}    ${CYAN}│${NC}"
echo -e "${CYAN}│${NC}  ${YELLOW}3.)☞${NC} ${WHITE}MENU TROJAN${NC}        ${YELLOW}10.)☞${NC} ${WHITE}MENU SYSTEM${NC}      ${CYAN}│${NC}"
echo -e "${CYAN}│${NC}  ${YELLOW}4.)☞${NC} ${WHITE}MENU VLESS${NC}         ${YELLOW}11.)☞${NC} ${WHITE}CEK RUNNING${NC}      ${CYAN}│${NC}"
echo -e "${CYAN}│${NC}  ${YELLOW}5.)☞${NC} ${WHITE}MENU WSS${NC}           ${YELLOW}12.)☞${NC} ${WHITE}REBOOT${NC}           ${CYAN}│${NC}"
echo -e "${CYAN}│${NC}  ${YELLOW}6.)☞${NC} ${WHITE}INSTAL UDP${NC}         ${YELLOW}13.)☞${NC} ${WHITE}MENU BACKUP${NC}      ${CYAN}│${NC}"
echo -e "${CYAN}│${NC}  ${YELLOW}7.)☞${NC} ${WHITE}BACKUP${NC}              ${YELLOW}x.)☞${NC} ${WHITE}EXIT${NC}             ${CYAN}│${NC}"
echo -e "${CYAN}└─────────────────────────────────────────────────┘${NC}"
# Footer
echo -e " ${CYAN}---------- t.me/caliphdev / @AjiStore ----------${NC}"
read -p " pilih menu [1-13 or x] : "  opt
echo -e   ""
    case $opt in
    1) clear ; m-sshovpn ;;
    2) clear ; m-vmess ;;
    3) clear ; m-vless ;;
    4) clear ; m-trojan ;;
    5) clear ; m-ssws ;;
    6) clear ; wget https://raw.githubusercontent.com/NevermoreSSH/Vergil/main/Tunnel/udp.sh && bash udp.sh ;;
    7) clear ; backup ;;
    8) clear ; m-bot-notif ;;
    9) clear ; update ;;
    10) clear ; m-system ;;
    11) clear ; running ;;
    12) clear ; reboot ;;
    13) clear ; m-backup ;;
    r) clear ; xray-renew ;;
    x) exit ;;
    *) echo "Silahkan masukkan pilihan dengan benar!" ; sleep 1 ; menu ;;
    esac
	
