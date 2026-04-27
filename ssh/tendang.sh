#!/bin/bash

# Konfigurasi Database
LIMIT_DB="/etc/ssh/limit.db"
XRAY_LIMIT="/etc/xray/limit.db"
DEFAULT_MAX=1
LOG="/var/log/auth.log" # Sesuaikan jika OS menggunakan log berbeda

# Fungsi untuk mendapatkan limit per user
get_limit() {
    local user=$1
    if [[ "$user" == *"trial"* ]]; then
        echo 999
    elif grep -qw "$user" "$LIMIT_DB" 2>/dev/null; then
        grep -w "$user" "$LIMIT_DB" | awk '{print $2}' | head -n1
    elif grep -qw "$user" "$XRAY_LIMIT" 2>/dev/null; then
        grep -w "$user" "$XRAY_LIMIT" | awk '{print $2}' | head -n1
    else
        echo "$DEFAULT_MAX"
    fi
}

# Ambil daftar user aktif
cat /etc/passwd | grep "/home/" | cut -d":" -f1 > /root/user.txt
username_list=( $(cat /root/user.txt) )

# Inisialisasi hitungan
hit=0
for ((i=0; i<${#username_list[@]}; i++)); do
    user="${username_list[$i]}"
# Menghitung sesi SSH yang benar-benar sedang ESTABLISHED (Aktif)
jumlah=$(netstat -anp | grep ESTABLISHED | grep sshd | grep -w "$user" | wc -l)
pids=$(ps aux | grep "sshd: $user" | grep -v grep | awk '{print $2}')
    
    USER_LIMIT=$(get_limit "$user")

    if [ "$jumlah" -gt "$USER_LIMIT" ]; then
        date=$(date +"%Y-%m-%d %X")
        echo "$date - $user - $jumlah (Limit: $USER_LIMIT)" >> /root/log-limit.txt
        
for pid in $pids; do
            kill -9 $pid >/dev/null 2>&1
        done
# Menghapus akun secara permanen dari sistem
userdel -f "$user"
sed -i "/^$user /d" /etc/ssh/limit.db
sed -i "/^$user /d" /etc/xray/limit.db
hit=$((hit + 1))
        
        # --- Notif Telegram AJI STORE ---
        KEY=$(grep -E "^#bot# " "/etc/bot/.bot.db" 2>/dev/null | head -n1 | cut -d ' ' -f 2)
        CHATID=$(grep -E "^#bot# " "/etc/bot/.bot.db" 2>/dev/null | head -n1 | cut -d ' ' -f 3)
        
        if [[ -n "$KEY" && -n "$CHATID" ]]; then
            TEXT="🗣️ <b>AKUN TERKENA LIMIT</b>
<code>────────────────────</code>
<b>Username : </b><code>$user</code>
<b>Limit IP : </b><code>$USER_LIMIT IP</code>
<b>Login Aktif: </b><code>$jumlah IP</code>
<b>Status   : </b><code>Kicked by System</code>
<code>────────────────────</code>"
            curl -s --max-time 10 -d "chat_id=$CHATID&text=$TEXT&parse_mode=html" "https://api.telegram.org/bot$KEY/sendMessage" >/dev/null
        fi
    fi
done

# Restart service jika ada yang ditendang
if [ "$hit" -gt 0 ]; then
    systemctl restart sshd >/dev/null 2>&1
fi
