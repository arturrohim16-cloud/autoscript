REDBLD="\033[0m\033[91;1m"
Green="\e[92;1m"
RED="\033[1;31m"
YELLOW="\033[33;1m"
BLUE="\033[36;1m"
FONT="\033[0m"
GREENBG="\033[42;37m"
REDBG="\033[41;37m"
NC='\e[0m'
MYIP=$(curl -sS ipv4.icanhazip.com)
IPVPS=$(curl -s ipv4.icanhazip.com)
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
domain=$(cat /etc/xray/domain)
NS=$(cat /etc/xray/dns)
RAM=$(free -m | awk 'NR==2 {print $2}')
USAGERAM=$(free -m | awk 'NR==2 {print $3}')
AUTH=$(grep AUTH_KEY /etc/environment | cut -d'=' -f2 | tr -d '"')
MEMOFREE=$(printf '%-1s' "$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')")
LOADCPU=$(printf '%-0.00001s' "$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')")
CPU=$(awk -F: '/model name/ {name=$2; exit} END {print name}' /proc/cpuinfo | sed 's/^ //')
CORES=$(awk -F: '/model name/ {c++} END {print c}' /proc/cpuinfo)
VENDOR=$(awk -F: '/vendor_id/ {vendor=$2; exit} END {print vendor}' /proc/cpuinfo | sed 's/^ //')
DATEVPS=$(date +'%d/%m/%Y')
TIMEZONE=$(printf '%(%H:%M:%S)T')
MODEL=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')
SERONLINE=$(uptime -p | cut -d " " -f 2-10000)
function print_install() {
echo -e "${BLUE} =============================== ${FONT}"
echo -e "${YELLOW} # $1 ${FONT}"
echo -e "${BLUE} =============================== ${FONT}"
sleep 1
}
function print_success() {
if [[ 0 -eq $? ]]; then
echo -e "${BLUE} =============================== ${FONT}"
echo -e "${Green} # $1 berhasil dipasang"
echo -e "${BLUE} =============================== ${FONT}"
sleep 2
fi
}
function Rename() {
clear
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo -e "\033[96;1m                      Welcome To Script ANSENDANT              \033[0m"
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo ""
sleep 3s
echo -e "    ----------------------------------"
echo -e "   |\e[1;32mPlease Select a Options \e[0m|"
echo -e "    ----------------------------------"
echo -e "     \e[1;32m1)\e[0m Rename Script"
echo -e "     \e[1;32m2)\e[0m Default "
echo -e "   ------------------------------------"
read -p "   Please select numbers 1-2 or Any Button(Default) : " host
echo ""
if [[ $host == "1" ]]; then
clear
echo ""
echo ""
echo -e "   \e[1;36m_______________________________$NC"
echo -e "   \e[1;32m      CHANGES NAME SCRIPT $NC"
echo -e "   \e[1;36m_______________________________$NC"
echo -e ""
read -p "   INPUT YOUR NAME :   " host1
read -p "   INPUT PAS ADMIN :   " host11
rm /etc/xray/username
if [[ $host11 == 123@Xwan ]]; then
echo $host1 >> /etc/xray/username
echo ""
clear
print_success "Rename Script"
sleep 3
menu
else
echo "ANSENDANT" > /etc/xray/username
clear
echo -e "${RED} Mohon Maaf Sepertinya Anda Bukan Owner ${NC}"
sleep 3
clear
echo -e "\033[1;93m────────────────────────────────────────────\033[0m"
echo -e "\033[42m          404 NOT FOUND AUTOSCRIPT          \033[0m"
echo -e "\033[1;93m────────────────────────────────────────────\033[0m"
echo -e ""
echo -e "            \033[91;1mPERMISSION DENIED !\033[0m"
echo -e "     \033[0;33mBuy access permissions for scripts\033[0m"
echo -e "             \033[0;33mContact Admin :\033[0m"
echo -e "      \033[2;32mWhatsApp\033[0m wa.me/6281774970898"
echo -e "      \033[2;32mTelegram\033[0m t.me/kytxz"
echo -e "\033[1;93m────────────────────────────────────────────\033[0m"
sleep 3
print_success "Script Name Default"
sleep 2
menu
fi
elif [[ $host == "2" ]]; then
rm /etc/xray/username
echo "ANSENDANT" > /etc/xray/username
clear
print_success "Script Name Default"
sleep 3
menu
fi
}
rm -f /usr/bin/user
username=$(curl -sS https://raw.githubusercontent.com/myridwan/izinvps2/ipuk/ipx | grep -wE $MYIP | awk '{print $2}')
echo "$username" >/usr/bin/user
rm -f /usr/bin/e
valid=$(curl -sS https://raw.githubusercontent.com/myridwan/izinvps2/ipuk/ipx | grep -wE $MYIP | awk '{print $3}')
echo "$valid" > /usr/bin/e
clear
username=$(cat /usr/bin/user)
oid=$(cat /usr/bin/ver)
exp=$(cat /usr/bin/e)
clear
d1=$(date -d "$valid" +%s)
d2=$(date -d "$today" +%s)
certifacate=$(((d1 - d2) / 86400))
if [[ $certifacate -le 0 ]]; then
masaaktif="EXPAIRED"
else
masaaktif="${certifacate} Day"
fi
clear
ssh_service=$(/etc/init.d/ssh status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
dropbear_service=$(/etc/init.d/dropbear status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
haproxy_service=$(systemctl status haproxy | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
xray_service=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
nginx_service=$(systemctl status nginx | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
clear
if [[ $ssh_service == "running" ]]; then
status_ssh="\033[92;1mON${NC}"
else
status_ssh="\033[91;1mOFF${NC} "
fi
ssh_ws=$( systemctl status ws | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ssh_ws == "running" ]]; then
status_ws_epro="\033[92;1mON${NC}"
else
status_ws_epro="\033[91;1mOFF${NC} "
fi
if [[ $haproxy_service == "running" ]]; then
status_haproxy="\033[92;1mON${NC}"
else
status_haproxy="\033[91;1mOFF${NC} "
fi
if [[ $xray_service == "running" ]]; then
status_xray="\033[92;1mON${NC}"
else
status_xray="\033[91;1mOFF${NC} "
fi
if [[ $nginx_service == "running" ]]; then
status_nginx="\033[92;1mON${NC}"
else
status_nginx="\033[91;1mOFF${NC} "
fi
if [[ $dropbear_service == "running" ]]; then
status_dropbear="\033[92;1mGOOD${NC}"
else
status_dropbear="\033[91;1mCRAZY${NC} "
fi
vlx=$(grep -c -E "^#& " "/etc/xray/config.json")
let vla=$vlx/2
vmc=$(grep -c -E "^### " "/etc/xray/config.json")
let vma=$vmc/2
ssh1="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
trx=$(grep -c -E "^#! " "/etc/xray/config.json")
let trb=$trx/2
ssx=$(grep -c -E "^#!# " "/etc/xray/config.json")
let ssa=$ssx/2
namax=$(cat /etc/xray/username 2>/dev/null)
[ -z "$namax" ] && namax="UNKNOWN"

function Xwan_Banner() {
clear

lebar_box=47
teks="${namax}"

hias_kiri="\033[38;5;196m⁙\033[38;5;202m⁙\033[38;5;208m⁙\033[38;5;214m⁙\033[38;5;220m⁙\033[38;5;226m⁙\033[38;5;190m⁙"
hias_kanan="\033[38;5;87m⁙\033[38;5;86m⁙\033[38;5;85m⁙\033[38;5;84m⁙\033[38;5;83m⁙\033[38;5;44m⁙\033[38;5;43m⁙"

panjang_hias_kiri=7
panjang_hias_kanan=7
panjang_teks=${#teks}

sisa=$(( lebar_box - panjang_hias_kiri - panjang_teks - panjang_hias_kanan ))

if [ "$sisa" -lt 0 ]; then
    sisa=0
fi

padding_kiri=$(( sisa / 2 ))
padding_kanan=$(( sisa - padding_kiri ))

spasi_kiri=$(printf "%*s" "$padding_kiri" "")
spasi_kanan=$(printf "%*s" "$padding_kanan" "")

echo -e "\033[36;1m┌─────────────────────────────────────────────────┐\033[0m"
echo -e "\033[36;1m│\e[97m${spasi_kiri}${hias_kiri} ${teks} ${hias_kanan}${spasi_kanan}\033[36;1m│\033[0m"
echo -e "\033[36;1m└─────────────────────────────────────────────────┘\033[0m"
}
function Service_System_Operating() {
echo -e "\033[36;1m┌─────────────────────────────────────────────────┐\033[0m "
echo -e "\033[36;1m│\e[97m SYSTEM OS       : $MODEL \033[0m "
echo -e "\033[36;1m│\e[97m CPU             : $VENDOR $CORES CORE \033[0m "
echo -e "\033[36;1m│\e[97m SERVER RAM      : $(free -m | awk 'NR==2 {print $3}')/$RAM MB  \033[0m "
echo -e "\033[36;1m│\e[97m UPTIME SERVER   : $SERONLINE \033[0m "
echo -e "\033[36;1m│\e[97m IP VPS          : $IPVPS \033[0m "
echo -e "\033[36;1m│\e[97m ISP             : $ISP \033[0m "
echo -e "\033[36;1m│\e[97m CITY            : $CITY \033[0m "
echo -e "\033[36;1m│\e[97m DOMAIN          : $domain \033[0m "
echo -e "\033[36;1m└─────────────────────────────────────────────────┘\033[0m"
}
function Service_Status() {
echo -e "\033[36;1m┌─────────────────────────────────────────────────┐\033[0m "
echo -e "\033[36;1m|\e[0m\033[33;1m PROXY :\e[0m $status_haproxy  ${BLUE}|\e[33m NGINX :\e[0m $status_nginx  ${BLUE}|\e[33m SSHWS :\e[0m $status_ws_epro ${BLUE}|  $status_dropbear  \033[36;1m| \e[0m "
echo -e "\033[36;1m└─────────────────────────────────────────────────┘\033[96;1m "
}
function Details_Clients_Name() {
echo -e "\033[36;1m   ┌───────────────────────────────────────────┐\033[0m "
echo -e "\033[36;1m   │\e[97m VERSION    : $(cat /opt/.ver)    \033[0m "
echo -e "\033[36;1m   │\e[97m STATUS     :\033[92;1m (active)    \033[0m "
echo -e "\033[36;1m   │\e[97m CLIENTS    :\033[0m\033[91;1m $(cat /usr/bin/user)      \033[0m "
echo -e "\033[36;1m   │\e[97m EXPIRY     : $exp / $(((d1 - d2) / 86400)) Day \033[0m "
echo -e "\033[36;1m   └───────────────────────────────────────────┘\033[0m "
}
function Acces_Use_Command() {
echo -e "${BLUE}┌─────────────────────────────────────────────────┐\033[0m "
echo -e "${BLUE}│  1.)\e[93m☞ \e[97m SSH/OPENVPN         ${BLUE}7.${BLUE})\e[93m☞ \e[97m BOT NOTIF      ${BLUE}│\e[0m"
echo -e "${BLUE}│  2.)\e[93m☞ \e[97m XRAY VMESS          ${BLUE}8.${BLUE})\e[93m☞ \e[97m UPDATE SCRIPT  ${BLUE}│\e[0m"
echo -e "${BLUE}│  3.)\e[93m☞ \e[97m XRAY TROJAN         ${BLUE}9.${BLUE})\e[93m☞ \e[97m BACKUP RESTORE ${BLUE}│\e[0m"
echo -e "${BLUE}│  4.)\e[93m☞ \e[97m XRAY VLESS         ${BLUE}10.${BLUE})\e[93m☞ \e[97m FEATURES       ${BLUE}│\e[0m"
echo -e "${BLUE}│  5.)\e[93m☞ \e[97m CHANGE DOMAIN      ${BLUE}11.${BLUE})\e[93m☞ \e[97m REBOOT         ${BLUE}│\e[0m"
echo -e "${BLUE}│  6.)\e[93m☞ \e[97m DOR PAKET XL        ${RED}x.${BLUE})\e[93m☞ \e[91m EXIT           ${BLUE}│\e[0m"
echo -e "${BLUE}└─────────────────────────────────────────────────┘\033[0m"
}
function Select_Display() {
echo
read -p "Select From option [1/11 or x] :  " hallo
case $hallo in
1) clear ; m-sshovpn ;;
2) clear ; m-vmess ;;
3) clear ; m-vless ;;
4) clear ; m-trojan ;;
5) clear ; m-ssws ;;
#6) clear ; m-l2tp ;;
#7) clear ; m-pptp ;;
#8) clear ; m-sstp ;;
9) clear ; m-system ;;
10) clear ; running ;;
11) clear ; clearcache ;;
12) clear ; reboot ; /sbin/reboot ;;
8) clear ; m-update ;;
6) clear ; wget https://raw.githubusercontent.com/NevermoreSSH/Vergil/main/Tunnel/udp.sh && bash udp.sh ;;
7) clear ; m-bot ;;
r) clear ; xray-renew ;;
x) exit ;;
*) echo "Silahkan masukkan pilihan dengan benar! " ; sleep 1 ; menu ;;
esac
}
Xwan_Banner
Service_System_Operating
Service_Status
Details_Clients_Name
Acces_Use_Command
Select_Display


