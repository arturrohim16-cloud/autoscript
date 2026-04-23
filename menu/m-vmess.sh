#!/bin/bash
# Definisi Warna Cerah
Nmr="\e[1;36m"      # Cyan Terang (Nomor)
Teks="\e[1;37m"     # Putih Bold (Teks Utama)
Line="\e[1;33m"     # Kuning Terang (Garis)
Back="\e[1;31m"     # Merah Terang (Kembali)
Header="\e[1;32m"   # Hijau Terang (Judul)
Reset="\e[0m"
clear
echo -e "${Line}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${Reset}"
echo -e "          ${Header}• VMESS WS (XRAY) MENU •${Reset}"
echo -e "${Line}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${Reset}"
echo -e ""
echo -e " [${Nmr}•1${Reset}] ${Teks}Create Vmess   ${Reset} │ [${Nmr}•4${Reset}] ${Teks}Delete Vmess   ${Reset}"
echo -e " [${Nmr}•2${Reset}] ${Teks}Trial Vmess    ${Reset} │ [${Nmr}•5${Reset}] ${Teks}Check Login    ${Reset}"
echo -e " [${Nmr}•3${Reset}] ${Teks}Extend Vmess   ${Reset} │ [${Nmr}•6${Reset}] ${Teks}User List      ${Reset}"
echo -e ""
echo -e " [${Back}•0${Reset}] ${Back}BACK TO MAIN MENU${Reset}"
echo -e "${Line}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${Reset}"
echo -e ""
read -p " Select menu :  "  opt
echo -e ""
case $opt in
1) clear ; add-ws ; exit ;;
2) clear ; trialvmess ; exit ;;
3) clear ; renew-ws ; exit ;;
4) clear ; del-ws ; exit ;;
5) clear ; cek-ws ; exit ;;
6) clear ; cat /etc/log-create-vmess.log ; exit ;;
0) clear ; menu ; exit ;;
x) exit ;;
*) echo "Anda salah tekan " ; sleep 1 ; m-sshovpn ;;
esac
