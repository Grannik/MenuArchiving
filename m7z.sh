#!/bin/bash
 
 E='echo -e';e='echo -en';trap "R;exit" 2
 ESC=$( $e "\e")
 TPUT(){ $e "\e[${1};${2}H" ;}
 CLEAR(){ $e "\ec";}
# 25 возможно это 
 CIVIS(){ $e "\e[?25l";}
# это цвет текста списка перед курсором при значении 0 в переменной  UNMARK(){ $e "\e[0m";}
 MARK(){ $e "\e[42m";}
# 0 это цвет заднего фона списка
 UNMARK(){ $e "\e[0m";}
# ~~~~~~~~ Эти строки задают цвет фона ~~~~~~~~
 R(){ CLEAR ;stty sane;CLEAR;};
#R(){ CLEAR ;stty sane;$e "\ec\e[37;44m\e[J";};
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 HEAD(){ for (( a=1; a<=15; a++ ))
  do
   TPUT $a 1
        $E "\xE2\x94\x82                                 \xE2\x94\x82";
  done
  TPUT 3 2
        $E "$(tput setaf 2)  Справочник $(tput sgr 0)";
  TPUT 12 2
        $E "$(tput setaf 2)  Up \xE2\x86\x91 \xE2\x86\x93 Down Select Enter$(tput sgr 0) ";
 MARK;TPUT 1 2
        $E " Программа написана на bash tput " ;UNMARK;}
   i=0; CLEAR; CIVIS;NULL=/dev/null
# 32 это расстояние сверху и 48 это расстояние слева
   FOOT(){ MARK;TPUT 15 2
# нижнее заглавие
        $E " *** Grannik | 2021.08.24  ***   ";UNMARK;}
# это управляет кнопками ввер/хвниз
 i=0; CLEAR; CIVIS;NULL=/dev/null
#
 ARROW(){ IFS= read -s -n1 key 2>/dev/null >&2
           if [[ $key = $ESC ]];then 
              read -s -n1 key 2>/dev/null >&2;
              if [[ $key = \[ ]]; then
                 read -s -n1 key 2>/dev/null >&2;
                 if [[ $key = A ]]; then echo up;fi
                 if [[ $key = B ]];then echo dn;fi
              fi
           fi
           if [[ "$key" == "$($e \\x0A)" ]];then echo enter;fi;}
# 4 и далее это отступ сверху и 48 это расстояние слева
 M0(){ TPUT  5 3; $e " Установить p7zip             ";}
 M1(){ TPUT  6 3; $e " Архивировать файл            ";}
 M2(){ TPUT  7 3; $e " Bыбрать формат архива        ";}
 M3(){ TPUT  8 3; $e " Установить пароль            ";}
 M4(){ TPUT  9 3; $e " Проверить целостность архивa ";}
 M5(){ TPUT 10 3; $e " Показать содержимое фрхива   ";}
 M6(){ TPUT 11 3; $e " Распаковать архив            ";}
#
 M7(){ TPUT 13 3; $e " EXIT                         ";}
# далее идет переменная LM=16 позволяющая выстраивать список в вертикаль.
LM=7
   MENU(){ for each in $(seq 0 $LM);do M${each};done;}
    POS(){ if [[ $cur == up ]];then ((i--));fi
           if [[ $cur == dn ]];then ((i++));fi
           if [[ $i -lt 0   ]];then i=$LM;fi
           if [[ $i -gt $LM ]];then i=0;fi;}
REFRESH(){ after=$((i+1)); before=$((i-1))
           if [[ $before -lt 0  ]];then before=$LM;fi
           if [[ $after -gt $LM ]];then after=0;fi
           if [[ $j -lt $i      ]];then UNMARK;M$before;else UNMARK;M$after;fi
           if [[ $after -eq 0 ]] || [ $before -eq $LM ];then
           UNMARK; M$before; M$after;fi;j=$i;UNMARK;M$before;M$after;}
   INIT(){ R;HEAD;FOOT;MENU;}
     SC(){ REFRESH;MARK;$S;$b;cur=`ARROW`;}
# Функция возвращения в меню
     ES(){ MARK;$e " ENTER = main menu ";$b;read;INIT;};INIT
  while [[ "$O" != " " ]]; do case $i in
# Здесь необходимо следить за двумя перепенными 0) и S=M0 Они должны совпадать между собой и переменной списка M0().
        0) S=M0;SC;if [[ $cur == enter ]];then R;echo "
 sudo apt-get install p7zip-full
";ES;fi;;
        1) S=M1;SC;if [[ $cur == enter ]];then R;echo "
 7z a file.7z file.png
";ES;fi;;
        2) S=M2;SC;if [[ $cur == enter ]];then R;echo "
 7z a -tzip file.zip file.png
";ES;fi;;
        3) S=M3;SC;if [[ $cur == enter ]];then R;echo "
 7z a -p file.7z
";ES;fi;;
        4) S=M4;SC;if [[ $cur == enter ]];then R;echo "
 7z t file.7z
";ES;fi;;
        5) S=M5;SC;if [[ $cur == enter ]];then R;echo "
 7z l file.7z
";ES;fi;;
        6) S=M6;SC;if [[ $cur == enter ]];then R;echo "
 7za e file.7z
";ES;fi;;
        7) S=M7;SC;if [[ $cur == enter ]];then R;clear;ls -l;exit 0;fi;;
 esac;POS;done
