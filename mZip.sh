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
        $E "\xE2\x94\x82                                                         \xE2\x94\x82";
  done
  TPUT 3 2
        $E "$(tput setaf 2)  \033[1mСправочник архив Zip\033[1m $(tput sgr 0)";
  TPUT 5 2
        $E "$(tput setaf 2) .zip $(tput sgr 0)";
  TPUT 17 2
        $E "$(tput setaf 2) .gzip $(tput sgr 0)";
  TPUT 22 2
        $E "$(tput setaf 2) Up \xE2\x86\x91 \xE2\x86\x93 Down Select Enter$(tput sgr 0) ";
 MARK;TPUT 1 2
        $E "  Программа написана на bash tput                        " ;UNMARK;}
   i=0; CLEAR; CIVIS;NULL=/dev/null
# 32 это расстояние сверху и 48 это расстояние слева
   FOOT(){ MARK;TPUT 25 2
        $E "  *** | Grannik | 2021.08.25 | ***                       ";UNMARK;}
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
 M0(){ TPUT  6 3; $e " Установить                                           ";}
 M1(){ TPUT  7 3; $e " Usage (использование)                                ";}
 M2(){ TPUT  8 3; $e " Создать zip-архив из файла                           ";}
 M3(){ TPUT  9 3; $e " Создать zip-архив из папки                           ";}
 M4(){ TPUT 10 3; $e " Создать zip-архив из нескольких файлов               ";}
 M5(){ TPUT 11 3; $e " Создать zip-архив зашифрованный из файлa             ";}
 M6(){ TPUT 12 3; $e " Создать zip-архив зашифрованный из нескольких файлов ";}
 M7(){ TPUT 13 3; $e " Создать zip-архив зашифрованный из папки             ";}
 M8(){ TPUT 14 3; $e " Pаспаковать zip-архив                                ";}
 M9(){ TPUT 15 3; $e " Pаспаковать zip-архив в другой каталог               ";}
M10(){ TPUT 16 3; $e " Pаспаковать все zip-архивы                           ";}
#
M11(){ TPUT 18 3; $e " Сжать и переименовать файл                           ";}
M12(){ TPUT 19 3; $e " Сжать и переименовать файл с максимальным сжатием    ";}
M13(){ TPUT 20 3; $e " Разжать и переименовать файл                         ";}
M14(){ TPUT 21 3; $e " Распаковать и переименовать файл                     ";}
#
M15(){ TPUT 23 3; $e " EXIT                                                 ";}
# далее идет переменная LM=16 позволяющая выстраивать список в вертикаль.
LM=15
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
 sudo apt install zip unzip
";ES;fi;;
        1) S=M1;SC;if [[ $cur == enter ]];then R;echo "
Usage: unzip [-Z] [-opts[modifiers]] file[.zip] [list] [-x xlist] [-d exdir]
  Default action is to extract files in list, except those in xlist, to exdir;
  file[.zip] may be a wildcard.  -Z => ZipInfo mode (\"unzip -Z\" for usage).
  -p  extract files to pipe, no messages     -l  list files (short format)
  -f  freshen existing files, create none    -t  test compressed archive data
  -u  update files, create if necessary      -z  display archive comment only
  -v  list verbosely/show version info       -T  timestamp archive to latest
  -x  exclude files that follow (in xlist)  
  -d  extract files into exdir modifiers | извлекать файлы в модификаторы exdir
  -n  never overwrite existing files         -q  quiet mode (-qq => quieter)
  -o  overwrite files WITHOUT prompting      -a  auto-convert any text files
  -j  junk paths (do not make directories)   -aa treat ALL files as text
  -U  use escapes for all non-ASCII Unicode  -UU ignore any Unicode fields
  -C  match filenames case-insensitively     -L  make (some) names lowercase
  -X  restore UID/GID info                   -V  retain VMS version numbers
  -K  keep setuid/setgid/tacky permissions   -M  pipe through \"more\" pager
  -O CHARSET  specify a character encoding for DOS, Windows and OS/2 archives
  -I CHARSET  specify a character encoding for UNIX and other archives
See \"unzip -hh\" or unzip.txt for more help.  Examples:
  unzip data1 -x joe   => extract all files except joe from zipfile data1.zip
  unzip -p foo | more  => send contents of foo.zip via pipe into program more
  unzip -fo foo ReadMe => quietly replace existing ReadMe if archive file newer 
";ES;fi;;
        2) S=M2;SC;if [[ $cur == enter ]];then R;echo "
 zip file1.zip file1
";ES;fi;;
        3) S=M3;SC;if [[ $cur == enter ]];then R;echo "
 zip -r mydir.zip ddir
";ES;fi;;
        4) S=M4;SC;if [[ $cur == enter ]];then R;echo "
 zip -r file1.zip file1 file2 dir1 
";ES;fi;;
        5) S=M5;SC;if [[ $cur == enter ]];then R;echo "
 zip -P password -r file.zip file
";ES;fi;;
        6) S=M6;SC;if [[ $cur == enter ]];then R;echo "
 zip --password MY_SECRET secure.zip doc.pdf doc2.pdf doc3.pdf
или
 zip --password 000 secure.zip * 
";ES;fi;;
        7) S=M7;SC;if [[ $cur == enter ]];then R;echo "
 zip -P мойпароль -r mysecretdir.zip mysecretdir 
";ES;fi;;
        8) S=M8;SC;if [[ $cur == enter ]];then R;echo "
 unzip file1.zip
";ES;fi;;
        9) S=M9;SC;if [[ $cur == enter ]];then R;echo "
 Pаспаковать файлы в другой каталог, команда будет выглядеть следующим образом:
 unzip zipname -d directoryname
";ES;fi;;
       10) S=M10;SC;if [[ $cur == enter ]];then R;echo "
 for f in *.zip ; do unzip \$f ; done
";ES;fi;;
#
       11) S=M11;SC;if [[ $cur == enter ]];then R;echo "
 gzip file
";ES;fi;;
       12) S=M12;SC;if [[ $cur == enter ]];then R;echo "
 gzip -9 file
";ES;fi;;
       13) S=M13;SC;if [[ $cur == enter ]];then R;echo "
 gzip -d file.gz
";ES;fi;;
       14) S=M14;SC;if [[ $cur == enter ]];then R;echo "
 gunzip file.gz
";ES;fi;;
#
       15) S=M15;SC;if [[ $cur == enter ]];then R;clear;ls -l;exit 0;fi;;
 esac;POS;done
