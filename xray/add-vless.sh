#!/bin/bash


source /var/lib/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi
tls="$(cat ~/log-install.txt | grep -w "Vless WS TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Vless WS none TLS" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;39m      Add Vless Account      \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)
	    read -p "Masukan Limit Login (IP): " iplimit
        # Jika input kosong, otomatis set ke 1
        if [ -z "$iplimit" ]; then iplimit="1"; fi
        # Simpan ke database limit xray
           echo "$user $iplimit" >> /etc/xray/limit.db

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
		echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
		echo -e "\E[44;1;39m      Add Vless Account      \E[0m"
		echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			echo ""
			read -n 1 -s -r -p "Press any key to back on menu"
			m-vless
		fi
	done

uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vless$/a\#vls '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vlessgrpc$/a\#vlsg '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json

vlesslink1="vless://${uuid}@${domain}:443?type=ws&encryption=none&security=tls&host=${domain}&path=/vless&allowInsecure=1&sni=${domain}#XRAY_VLESS_TLS_${user}"
vlesslink2="vless://${uuid}@${domain}:80?type=ws&encryption=none&security=none&host=${domain}&path=/vless#XRAY_VLESS_NTLS_${user}"
vlesslink3="vless://${uuid}@${domain}:$tls?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=${domain}#VLESS_GRPC_${user}"
systemctl restart xray
# ==============================
# NOTIFIKASI TELEGRAM VLESS
# ==============================
KEY=$(grep -E "^#bot# " "/etc/bot/.bot.db" 2>/dev/null | head -n1 | cut -d ' ' -f 2 || echo "")
CHATIDS=$(grep -E "^#bot# " "/etc/bot/.bot.db" 2>/dev/null | cut -d ' ' -f 3 || echo "")
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"

TEXT="🚀 <b>VLESS ACCOUNT CREATED</b> 🚀
━━━━━━━━━━━━━━━━━━━━━
👤 <b>User:</b> <code>${user}</code>
🆔 <b>UUID:</b> <code>${uuid}</code>
📅 <b>Exp:</b> <code>${exp}</code>
━━━━━━━━━━━━━━━━━━━━━
🌐 <b>Domain:</b> <code>${domain}</code>
🔐 <b>Port TLS:</b> <code>${tls}</code>
🔓 <b>Port Non TLS:</b> <code>${none}</code>
🚀 <b>gRPC:</b> <code>${tls}</code>
🛣 <b>Path:</b> <code>/vless</code>
━━━━━━━━━━━━━━━━━━━━━
🔗 <b>Link TLS:</b>
<code>${vlesslink1}</code>
━━━━━━━━━━━━━━━━━━━━━
🔗 <b>Link Non TLS:</b>
<code>${vlesslink2}</code>
━━━━━━━━━━━━━━━━━━━━━
🔗 <b>Link gRPC:</b>
<code>${vlesslink3}</code>
━━━━━━━━━━━━━━━━━━━━━
✅ <b>ANSENDANTVPN</b>"

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
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-vless.log
echo -e "\E[44;1;39m        Vless Account        \E[0m" | tee -a /etc/log-create-vless.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-vless.log
echo -e "Remarks        : ${user}" | tee -a /etc/log-create-vless.log
echo -e "Domain         : ${domain}" | tee -a /etc/log-create-vless.log
echo -e "Wildcard       : (bug.com).${domain}" | tee -a /etc/log-create-vless.log
echo -e "Port TLS       : $tls" | tee -a /etc/log-create-vless.log
echo -e "Port none TLS  : $none" | tee -a /etc/log-create-vless.log
echo -e "id             : ${uuid}" | tee -a /etc/log-create-vless.log
echo -e "Encryption     : none" | tee -a /etc/log-create-vless.log
echo -e "Network        : ws" | tee -a /etc/log-create-vless.log
echo -e "Path           : /vless" | tee -a /etc/log-create-vless.log
echo -e "Path           : vless-grpc" | tee -a /etc/log-create-vless.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-vless.log
echo -e "Link TLS       : ${vlesslink1}" | tee -a /etc/log-create-vless.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-vless.log
echo -e "Link none TLS  : ${vlesslink2}" | tee -a /etc/log-create-vless.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-vless.log
echo -e "Link gRPC      : ${vlesslink3}" | tee -a /etc/log-create-vless.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-vless.log
echo -e "Expired On     : $exp" | tee -a /etc/log-create-vless.log
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-vless.log
echo "" | tee -a /etc/log-create-vless.log
read -n 1 -s -r -p "Press any key to back on menu"

m-vless
