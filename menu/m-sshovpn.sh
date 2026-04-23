#!/bin/bash

# Definisi Warna
warna_nomor="\e[36m"
warna_teks="\e[1;37m"
warna_border="\e[33m"
warna_reset="\e[0m"
warna_back="\e[31m"
warna_header="\E[0;100;33m"

echo -e "${warna_border}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${warna_reset}"
echo -e "${warna_header}                 • SSH MENU •                    ${warna_reset}"
echo -e "${warna_border}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${warna_reset}"
echo -e ""
echo -e " [${warna_nomor}•1${warna_reset}] ${warna_teks}Create SSH & WS ${warna_reset} │ [${warna_nomor}•8${warna_reset}] ${warna_teks}Autokill SSH  ${warna_reset}"
echo -e " [${warna_nomor}•2${warna_reset}] ${warna_teks}Trial SSH & WS  ${warna_reset} │ [${warna_nomor}•9${warna_reset}] ${warna_teks}Multi Login   ${warna_reset}"
echo -e " [${warna_nomor}•3${warna_reset}] ${warna_teks}Renew SSH & WS  ${warna_reset} │ [${warna_nomor}•10${warna_reset}]${warna_teks}User List     ${warna_reset}"
echo -e " [${warna_nomor}•4${warna_reset}] ${warna_teks}Delete SSH & WS ${warna_reset} │ [${warna_nomor}•11${warna_reset}]${warna_teks}Change Banner ${warna_reset}"
echo -e " [${warna_nomor}•5${warna_reset}] ${warna_teks}Check Login     ${warna_reset} │ [${warna_nomor}•12${warna_reset}]${warna_teks}Lock User     ${warna_reset}"
echo -e " [${warna_nomor}•6${warna_reset}] ${warna_teks}Member List     ${warna_reset} │ [${warna_nomor}•13${warna_reset}]${warna_teks}Unlock User   ${warna_reset}"
echo -e " [${warna_nomor}•7${warna_reset}] ${warna_teks}Delete Expired  ${warna_reset} │"
echo -e ""
echo -e " [${warna_back}•0${warna_reset}] ${warna_back}BACK TO MAIN MENU${warna_reset}"
echo -e "${warna_border}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${warna_reset}"
echo -e   "Press x or [ Ctrl+C ] • To-Exit"
echo ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p " Select menu :  "  opt
echo -e ""
case $opt in
1) clear ; usernew ; exit ;;
2) clear ; trial ; exit ;;
3) clear ; renew ; exit ;;
4) clear ; hapus ; exit ;;
5) clear ; cek ; exit ;;
6) clear ; member ; exit ;;
7) clear ; delete ; exit ;;
8) clear ; autokill ; exit ;;
9) clear ; ceklim ; exit ;;
10) clear ; cat /etc/log-create-ssh.log ; exit ;;
11) clear ; nano /etc/issue.net ; exit ;;
12) clear ; user-lock ; exit ;;
13) clear ; user-unlock ; exit ;;
0) clear ; menu ; exit ;;
x) exit ;;
*) echo "Anda salah tekan " ; sleep 1 ; m-sshovpn ;;
esac
