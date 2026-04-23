#!/bin/bash
# CARI APA
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m          • SSH MENU •             \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e " [\e[36m•1\e[0m] \e[1;37mCreate SSH & WS Account\e[0m"
echo -e " [\e[36m•2\e[0m] \e[1;37mTrial SSH & WS Account\e[0m"
echo -e " [\e[36m•3\e[0m] \e[1;37mRenew SSH & WS Account\e[0m"
echo -e " [\e[36m•4\e[0m] \e[1;37mDelete SSH & WS Account\e[0m"
echo -e " [\e[36m•5\e[0m] \e[1;37mCheck User Login SSH & WS\e[0m"
echo -e " [\e[36m•6\e[0m] \e[1;37mList Member SSH & WS\e[0m"
echo -e " [\e[36m•7\e[0m] \e[1;37mDelete User Expired SSH & WS\e[0m"
echo -e " [\e[36m•8\e[0m] \e[1;37mSet up Autokill SSH\e[0m"
echo -e " [\e[36m•9\e[0m] \e[1;37mCek Users Who Do Multi Login\e[0m"
echo -e " [\e[36m•10\e[0m] \e[1;37mUser list created Account\e[0m"
echo -e " [\e[36m•11\e[0m] \e[1;37mChange Banner SSH\e[0m"
echo -e " [\e[36m•12\e[0m] \e[1;37mSet Lock User\e[0m"
echo -e " [\e[36m•13\e[0m] \e[1;37mSet Unlock User\e[0m"
echo -e ""
echo -e " [\e[31m•0\e[0m] \e[31mBACK TO MENU\033[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
# CARI APAecho -e ""
echo -e   "Press x or [ Ctrl+C ] • To-Exit"
echo ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
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
