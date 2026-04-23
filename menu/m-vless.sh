#!/bin/bash

# Definisi Warna Kontras Tinggi
Nmr="\e[1;36m"      # Cyan Terang (Nomor)
Teks="\e[1;37m"     # Putih Bold (Teks Utama)
Line="\e[1;35m"     # Magenta/Ungu (Garis)
Back="\e[1;31m"     # Merah Terang (Kembali)
Header="\e[1;45;37m" # Background Ungu, Teks Putih (Header)
Reset="\e[0m"

echo -e "${Line}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${Reset}"
echo -e "          ${Header}          • VLESS MENU •         ${Reset}"
echo -e "${Line}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${Reset}"
echo -e ""
echo -e " [${Nmr}•1${Reset}] ${Teks}Create Vless   ${Reset} │ [${Nmr}•4${Reset}] ${Teks}Delete Vless   ${Reset}"
echo -e " [${Nmr}•2${Reset}] ${Teks}Trial Vless    ${Reset} │ [${Nmr}•5${Reset}] ${Teks}Check Login    ${Reset}"
echo -e " [${Nmr}•3${Reset}] ${Teks}Extend Vless   ${Reset} │ [${Nmr}•6${Reset}] ${Teks}User List      ${Reset}"
echo -e ""
echo -e " [${Back}•0${Reset}] ${Back}BACK TO MENU${Reset}     [${Back}•x${Reset}] ${Back}EXIT SCRIPT${Reset}"
echo -e ""
echo -e " ${Teks}Press [ Ctrl+C ] to Force Exit${Reset}"
echo -e "${Line}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${Reset}"
echo -e ""
read -p " Select menu :  "  opt
echo -e ""
case $opt in
1) clear ; add-vless ; exit ;;
2) clear ; trialvless ; exit ;;
3) clear ; renew-vless ; exit ;;
4) clear ; del-vless ; exit ;;
5) clear ; cek-vless ; exit ;;
6) clear ; cat /etc/log-create-vless.log ; exit ;;
0) clear ; menu ; exit ;;
x) exit ;;
*) echo "Anda salah tekan " ; sleep 1 ; m-sshovpn ;;
esac
