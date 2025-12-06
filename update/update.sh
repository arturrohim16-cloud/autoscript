#!/bin/bash
###########- COLOR CODE -##############
colornow=$(cat /etc/rmbl/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m"
COLOR1="$(cat /etc/rmbl/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/rmbl/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'
###########- END COLOR CODE -##########

echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${WH}          UPDATE SCRIPT BY CALIPHDEV           ${NC} $COLOR1│${NC}"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e ""
echo -e "  \033[1;91m Update Script...\033[1;37m"

# Define base URL
BASE_URL="https://autoscript.caliphdev.com"

# Check versions
LOCAL_VER=$(cat /opt/.ver)
NEW_VER=$(curl -sS "$BASE_URL/menu/versi")

echo -e "  Current Version : $LOCAL_VER"
echo -e "  New Version     : $NEW_VER"
echo -e ""

if [ "$LOCAL_VER" == "$NEW_VER" ]; then
    echo -e "  [${WH}INFO${NC}] You are already on the latest version."
    read -p "  Do you still want to force update? [y/N]: " force_update
    if [[ "$force_update" != "y" && "$force_update" != "Y" ]]; then
        exit 0
    fi
fi

echo -e "  Starting update..."
sleep 1

# Function to download and install a file
update_file() {
    local file_path=$1
    local file_url=$2
    local tmp_file="/tmp/$(basename "$file_path")"

    # echo -e "  Downloading $(basename "$file_path")..."
    if wget -q -O "$tmp_file" "$file_url"; then
        mv "$tmp_file" "$file_path"
        chmod +x "$file_path"
        echo -e "  [${WH}OK${NC}] Updated $(basename "$file_path")"
    else
        echo -e "  [${RED}FAIL${NC}] Failed to download $(basename "$file_path")"
    fi
}

# --- MENU & SYSTEM ---
update_file "/usr/bin/menu" "$BASE_URL/menu/menu.sh"
update_file "/usr/bin/m-vmess" "$BASE_URL/menu/m-vmess.sh"
update_file "/usr/bin/m-vless" "$BASE_URL/menu/m-vless.sh"
update_file "/usr/bin/running" "$BASE_URL/menu/running.sh"
update_file "/usr/bin/clearcache" "$BASE_URL/menu/clearcache.sh"
update_file "/usr/bin/m-ssws" "$BASE_URL/menu/m-ssws.sh"
update_file "/usr/bin/m-trojan" "$BASE_URL/menu/m-trojan.sh"
update_file "/usr/bin/m-system" "$BASE_URL/menu/m-system.sh"
update_file "/usr/bin/m-domain" "$BASE_URL/menu/m-domain.sh"
update_file "/usr/bin/auto-reboot" "$BASE_URL/menu/auto-reboot.sh"
update_file "/usr/bin/restart" "$BASE_URL/menu/restart.sh"
update_file "/usr/bin/bw" "$BASE_URL/menu/bw.sh"
update_file "/usr/bin/m-tcp" "$BASE_URL/menu/tcp.sh"
update_file "/usr/bin/m-dns" "$BASE_URL/menu/m-dns.sh"
update_file "/usr/bin/m-l2tp" "$BASE_URL/menu/m-l2tp.sh"
update_file "/usr/bin/m-sstp" "$BASE_URL/menu/m-sstp.sh"
update_file "/usr/bin/m-pptp" "$BASE_URL/menu/m-pptp.sh"
update_file "/usr/bin/m-update" "$BASE_URL/update/update.sh"

# --- SSH / OVPN ---
update_file "/usr/bin/m-sshovpn" "$BASE_URL/menu/m-sshovpn.sh"
update_file "/usr/bin/usernew" "$BASE_URL/ssh/usernew.sh"
update_file "/usr/bin/trial" "$BASE_URL/ssh/trial.sh"
update_file "/usr/bin/renew" "$BASE_URL/ssh/renew.sh"
update_file "/usr/bin/hapus" "$BASE_URL/ssh/hapus.sh"
update_file "/usr/bin/cek" "$BASE_URL/ssh/cek.sh"
update_file "/usr/bin/member" "$BASE_URL/ssh/member.sh"
update_file "/usr/bin/delete" "$BASE_URL/ssh/delete.sh"
update_file "/usr/bin/autokill" "$BASE_URL/ssh/autokill.sh"
update_file "/usr/bin/ceklim" "$BASE_URL/ssh/ceklim.sh"
update_file "/usr/bin/tendang" "$BASE_URL/ssh/tendang.sh"
update_file "/usr/bin/sshws" "$BASE_URL/ssh/sshws.sh"
update_file "/usr/bin/user-lock" "$BASE_URL/ssh/user-lock.sh"
update_file "/usr/bin/user-unlock" "$BASE_URL/ssh/user-unlock.sh"
update_file "/usr/bin/add-host" "$BASE_URL/ssh/add-host.sh"
update_file "/usr/bin/speedtest" "$BASE_URL/ssh/speedtest_cli.py"
update_file "/usr/bin/xp" "$BASE_URL/ssh/xp.sh"
update_file "/usr/bin/badvpn-udpgw" "$BASE_URL/ssh/newudpgw"

# --- XRAY ---
update_file "/usr/bin/certv2ray" "$BASE_URL/xray/certv2ray.sh"
update_file "/usr/bin/xray-renew" "$BASE_URL/xray/xray-renew.sh"
update_file "/usr/bin/add-ws" "$BASE_URL/xray/add-ws.sh"
update_file "/usr/bin/trialvmess" "$BASE_URL/xray/trialvmess.sh"
update_file "/usr/bin/renew-ws" "$BASE_URL/xray/renew-ws.sh"
update_file "/usr/bin/del-ws" "$BASE_URL/xray/del-ws.sh"
update_file "/usr/bin/cek-ws" "$BASE_URL/xray/cek-ws.sh"
update_file "/usr/bin/add-vless" "$BASE_URL/xray/add-vless.sh"
update_file "/usr/bin/trialvless" "$BASE_URL/xray/trialvless.sh"
update_file "/usr/bin/renew-vless" "$BASE_URL/xray/renew-vless.sh"
update_file "/usr/bin/del-vless" "$BASE_URL/xray/del-vless.sh"
update_file "/usr/bin/cek-vless" "$BASE_URL/xray/cek-vless.sh"
update_file "/usr/bin/add-tr" "$BASE_URL/xray/add-tr.sh"
update_file "/usr/bin/trialtrojan" "$BASE_URL/xray/trialtrojan.sh"
update_file "/usr/bin/del-tr" "$BASE_URL/xray/del-tr.sh"
update_file "/usr/bin/renew-tr" "$BASE_URL/xray/renew-tr.sh"
update_file "/usr/bin/cek-tr" "$BASE_URL/xray/cek-tr.sh"
update_file "/usr/bin/add-ssws" "$BASE_URL/xray/add-ssws.sh"
update_file "/usr/bin/trialssws" "$BASE_URL/xray/trialssws.sh"
update_file "/usr/bin/del-ssws" "$BASE_URL/xray/del-ssws.sh"
update_file "/usr/bin/renew-ssws" "$BASE_URL/xray/renew-ssws.sh"

# --- IPSEC ---
update_file "/usr/bin/addl2tp" "$BASE_URL/ipsec/addl2tp.sh"
update_file "/usr/bin/dell2tp" "$BASE_URL/ipsec/dell2tp.sh"
update_file "/usr/bin/addpptp" "$BASE_URL/ipsec/addpptp.sh"
update_file "/usr/bin/delpptp" "$BASE_URL/ipsec/delpptp.sh"
update_file "/usr/bin/renewpptp" "$BASE_URL/ipsec/renewpptp.sh"
update_file "/usr/bin/renewl2tp" "$BASE_URL/ipsec/renewl2tp.sh"

# --- SSTP ---
update_file "/usr/bin/addsstp" "$BASE_URL/sstp/addsstp.sh"
update_file "/usr/bin/delsstp" "$BASE_URL/sstp/delsstp.sh"
update_file "/usr/bin/ceksstp" "$BASE_URL/sstp/ceksstp.sh"
update_file "/usr/bin/renewsstp" "$BASE_URL/sstp/renewsstp.sh"


# Update version file
if [ -n "$NEW_VER" ]; then
    echo "$NEW_VER" > /opt/.ver
    echo -e "  [${WH}OK${NC}] Version updated to $NEW_VER"
else
    echo -e "  [${RED}FAIL${NC}] Failed to fetch version"
fi

echo -e ""
echo -e "  \033[1;91m Update Done...\033[1;37m"
sleep 2
menu
