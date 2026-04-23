#!/bin/bash

echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m       • VMESS MENU •         \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " [${warna_nomor}•1${warna_reset}] ${warna_teks}Create Account Vmess     ${warna_reset} │ ${warna_reset}"
echo -e " [${warna_nomor}•2${warna_reset}] ${warna_teks}Trial Account Vmess      ${warna_reset} │ ${warna_reset}"
echo -e " [${warna_nomor}•3${warna_reset}] ${warna_teks}Extending Account Vmess  ${warna_reset} │ ${warna_reset}"
echo -e " [${warna_nomor}•4${warna_reset}] ${warna_teks}Delete Account Vmess     ${warna_reset} │ ${warna_reset}"
echo -e " [${warna_nomor}•5${warna_reset}] ${warna_teks}Check User Login Vmess   ${warna_reset} │ ${warna_reset}"
echo -e " [${warna_nomor}•6${warna_reset}] ${warna_teks}User list created Account${warna_reset} │ ${warna_reset}"
echo -e " [${warna_nomor}•x${warna_reset}] ${warna_teks}BACK TO MENU ${warna_reset} │"
echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
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
