#!/bin/bash

argv=("$@");

isCompact=false;
showStatistics=false;
projectDir="";

showHelp() {
  echo '
    Unit tester - CLI for simple C code testing.

    Syntax:

    utest [ switchers ] --project <project-directory>

    ------------------------------------------------------

    switchers:

    --help :

      | Shows this help page :)

    --project <project-directory> :

      | Tells the script "this is the directory of my project which I want to test". 

    --compact :

      | Shows only test results.

    --full :

      | Shows the whole process of testing including printing projects stdout into the terminal.
      | Recommended for the maximum effect.
  '
};

for ((i=1; i <= $#; i++)); do
  if [ "${argv[$i - 1]}" == "--compact" ]; then
    isCompact=true;
  elif [ "${argv[$i - 1]}" == "--full" ]; then
    isCompact=false;
  elif [ "${argv[$i - 1]}" == "--project" ]; then
    projectDir="${argv[$i]}";
  elif [ "${argv[$i - 1]}" == "--show-statistics" ]; then
    showStatistics=true;
  elif [ $1 == "--help" ]; then
    showHelp
    exit 0;
  fi
done

fullTest() {
  for dir in "$projectDir"; do
    echo \ 
    echo '###################################################################################################################################'
    echo "            Testing $(basename $dir)                             "
    echo '###################################################################################################################################'
    echo \ 
    cd $dir

    for inp in $(ls "inputs"); do
        echo "##################################################################"
        echo "testing input.. $(basename $inp)"
        echo "-------------------------- inputs --------------------------------"
        cat inputs/$inp
        echo "+----------------------- test result ----------------------------+"
        g++ main.c -Wall -pedantic -o main
        ./main < inputs/$inp && echo -e "\e[1;32m[ PASSED ]\e[0m" || echo -e "\e[1;31m[ FAILED!!! ]\e[0m"
        echo '##################################################################'
        echo \ 
        echo \ 
        echo \ 
    done
    cd ../
  done
};

compactTest() {
  for dir in "$projectDir"; do
    echo \ 
    echo '###################################################################################################################################'
    echo "            Testing $(basename $dir)                             "
    echo '###################################################################################################################################'
    echo \ 
    cd $dir

    for inp in $(ls "inputs"); do
        g++ main.c -Wall -pedantic -o main
        ./main < inputs/$inp 1> /dev/null && echo -e "testing input.. $(basename $inp) : \e[1;32m[ PASSED ]\e[0m" || echo -e "testing input.. $(basename $inp) : \e[1;31m[ FAILED!!! ]\e[0m"
    done
    echo \ 
    cd ../
  done
};

if [ $isCompact == false ]; then
  fullTest
else
  compactTest 
fi

exit 0;
