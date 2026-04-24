#!/bin/bash

# Ganti baris 3-20 dengan ini:
LIMIT_DB="/etc/ssh/limit.db"
DEFAULT_MAX=1

# Fungsi untuk mendapatkan limit per user
get_limit() {
    local user=$1
    if [[ "$user" == *"trial"* ]]; then
        echo 999
    # Cek di database SSH
    elif grep -qw "$user" "/etc/ssh/limit.db"; then
        grep -w "$user" "/etc/ssh/limit.db" | awk '{print $2}'
    # Cek di database Xray
    elif grep -qw "$user" "/etc/xray/limit.db"; then
        grep -w "$user" "/etc/xray/limit.db" | awk '{print $2}'
    else
        echo "$DEFAULT_MAX"
    fi
}
else
    service sshd restart > /dev/null 2>&1
fi
# Ambil daftar user di /home
cat /etc/passwd | grep "/home/" | cut -d":" -f1 > /root/user.txt
username_list=( $(cat /root/user.txt) )
jumlah=()
pid=()

for ((i=0; i<${#username_list[@]}; i++)); do
    jumlah[$i]=0
    pid[$i]=""
done

# Ambil log login SSH
grep -i sshd $LOG | grep -i "Accepted password for" > /tmp/log-ssh.txt

# Ambil pid ssh sesi aktif
proc=( $(ps aux | grep "\[priv\]" | awk '{print $2}') )

for PID in "${proc[@]}"; do
    grep "sshd\[$PID\]" /tmp/log-ssh.txt > /tmp/log-ssh-pid.txt
    NUM=$(wc -l < /tmp/log-ssh-pid.txt)
    USER=$(awk '{print $9}' /tmp/log-ssh-pid.txt)
    IP=$(awk '{print $11}' /tmp/log-ssh-pid.txt)

    if [ "$NUM" -eq 1 ]; then
        for ((i=0; i<${#username_list[@]}; i++)); do
            if [ "$USER" == "${username_list[$i]}" ]; then
                jumlah[$i]=$((jumlah[$i] + 1))
                pid[$i]="${pid[$i]} $PID"
            fi
        done
    fi
done

# Eksekusi kill jika lebih dari MAX
# Baris asli: if [ ${jumlah[$i]} -gt $MAX ]; then
USER_LIMIT=$(get_limit "${username_list[$i]}")
if [ ${jumlah[$i]} -gt $USER_LIMIT ]; then
        date=$(date +"%Y-%m-%d %X")
        echo "$date - ${username_list[$i]} - ${jumlah[$i]}"
        echo "$date - ${username_list[$i]} - ${jumlah[$i]}" >> /root/log-limit.txt
        kill ${pid[$i]}
        hit=$((hit + 1))
        TEXT=" <<-EOF
<code>────────────────────</code>
<b>   ⚠️ SSH AUTOKILL ⚠️</b>
<code>────────────────────</code>
<b>Username : </b><code>${username_list[$i]}</code>
<b>Limit IP : </b><code>$USER_LIMIT IP</code>
<b>Status   : </b><code>Terkena Limit & Kicked</code>
<code>────────────────────</code>
<i>Notifikasi Otomatis AJI STORE</i>
EOF
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
# --- AKHIR KODE NOTIF TELEGRAM ---
    fi
done

# Restart ssh jika ada yang dikill
if [ $hit -gt 0 ]; then
    if [ $OS -eq 1 ]; then
        service ssh restart > /dev/null 2>&1
    else
        service sshd restart > /dev/null 2>&1
    fi
fi
