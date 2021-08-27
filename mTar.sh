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
 HEAD(){ for (( a=1; a<=25; a++ ))
  do
   TPUT $a 1
        $E "\xE2\x94\x82                                                 \xE2\x94\x82";
  done
 TPUT 3 2
        $E "$(tput setaf 2)\033[1m  Справочник архив tar$(tput sgr 0)";
 TPUT 5 2
        $E "$(tput setaf 2) .tar $(tput sgr 0) ";
 TPUT 12 2
        $E "$(tput setaf 2) .tar.gz $(tput sgr 0) ";
 TPUT 16 2
        $E "$(tput setaf 2) .tar.bz2 $(tput sgr 0) ";
 TPUT 19 2
        $E "$(tput setaf 2) .tgz архив с компрессией $(tput sgr 0) ";
 TPUT 22 2
        $E "$(tput setaf 2) Up \xE2\x86\x91 \xE2\x86\x93 Down Select Enter$(tput sgr 0) ";
 MARK;TPUT 1 2
        $E "  Программа написана на bash tput                " ;UNMARK;}
   i=0; CLEAR; CIVIS;NULL=/dev/null
# 32 это расстояние сверху и 48 это расстояние слева
   FOOT(){ MARK;TPUT 25 2
# нижнее заглавие
        $E "  *** | Grannik | 2021.08.24 | ***               ";UNMARK;}
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
 M0(){ TPUT  6 3; $e " Используемые ключи                           ";}
 M1(){ TPUT  7 3; $e " Cоздать tar-архив, содержащий файл или файлы ";}
 M2(){ TPUT  8 3; $e " Cоздать tar-архив с именем                   ";}
 M3(){ TPUT  9 3; $e " Показать содержимое архива                   ";}
 M4(){ TPUT 10 3; $e " Распаковать архив                            ";}
 M5(){ TPUT 11 3; $e " Распаковать архив в папку                    ";}
#
 M6(){ TPUT 13 3; $e " Cоздать архив tar с сжатием Gzip             ";}
 M7(){ TPUT 14 3; $e " Распаковать tar с Gzip                       ";}
 M8(){ TPUT 15 3; $e " Распаковка .tar.gz файлов в .tar             ";}
#
 M9(){ TPUT 17 3; $e " Cоздать архив tar с сжатием Bzip2            ";}
M10(){ TPUT 18 3; $e " Распаковать tar с Bzip2                      ";}
#
M11(){ TPUT 20 3; $e " Cоздать архив с компрессией                  ";}
M12(){ TPUT 21 3; $e " Распаковать архив                            ";}
#
M13(){ TPUT 23 3; $e " EXIT                                         ";}
LM=13
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
 -c                  создать новый архив
 -f                  используется вместе с ключом -с, для создания файла архива с именем, указанного после ключей
 -v                  показывать ход выполнения
 -d --diff --compare поиск различий между архивом и файловой системой
    --delete         удаление из архива (не на магнитных лентах!)
 -r --append         добавление файлов в конец архива
 -t --list           вывод списка содержимого архива
    --test-label     проверка метки тома архива и выход
 -j                  означает создать архив, с помощью bzip
 -u --update         добавление в архив только более новых файлов
 -x --extract --get  извлечение файлов из архива
 -z                  создать архив, с помощью gzip
";ES;fi;;
        1) S=M1;SC;if [[ $cur == enter ]];then R;echo "
 tar -cvf archive.tar file file1 file2
";ES;fi;;
        2) S=M2;SC;if [[ $cur == enter ]];then R;echo "
 tar cf file.tar files
";ES;fi;;
        3) S=M3;SC;if [[ $cur == enter ]];then R;echo "
 tar -tf archive.tar
";ES;fi;;
        4) S=M4;SC;if [[ $cur == enter ]];then R;echo "
 tar -xvf archive.tar
или
 tar xf file.tar
";ES;fi;;
        5) S=M5;SC;if [[ $cur == enter ]];then R;echo "
 tar -xvf archive.tar -C /home/Pictures
";ES;fi;;
        6) S=M6;SC;if [[ $cur == enter ]];then R;echo "
 tar czf file.tar.gz file
";ES;fi;;
        7) S=M7;SC;if [[ $cur == enter ]];then R;echo "
 tar xzf file.tar.gz
или
 tar zxvf filename.tar.gz
";ES;fi;;
        8) S=M8;SC;if [[ $cur == enter ]];then R;echo "
 gunzip filename.tar.gz
";ES;fi;;
        9) S=M9;SC;if [[ $cur == enter ]];then R;echo "
 tar cjf file.tar.bz2 file
";ES;fi;;
       10) S=M10;SC;if [[ $cur == enter ]];then R;echo "
 tar xjf file.tar.bz2 file
";ES;fi;;
       11) S=M11;SC;if [[ $cur == enter ]];then R;echo "
 tar -czvf имя_файла.tgz каталог/файл
";ES;fi;;
       12) S=M12;SC;if [[ $cur == enter ]];then R;echo "
 tar -xzvf имя_файла.tgz
";ES;fi;;
       13) S=M13;SC;if [[ $cur == enter ]];then R;clear;ls -l;exit 0;fi;;
 esac;POS;done
