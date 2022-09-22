#!/bin/bash

# constants
quiz_file=quiz.txt
score=0

stty -echo

function slow() {
    for ((i=0; i<${#1} ; i++)) ; do 
        echo -n "${1:i:1}"
        sleep 0.07
    done
}
# check if quiz file exists
if [ ! -f $quiz_file ]
then
    echo "Quiz file doesnt exist!"
    exit 1
fi
QCOUNT="`wc -l $quiz_file | cut -f1 -d' '`"

#clear
GREEN='\033[0;32m'
#RED='\033[0;31m'

function quiz() {
score=0
# game loop (loop over quiz file line/line)
while read -u9 line
do
    printf "$GREEN%s%*s\n" 
    # parsing quiz file for current question
    question=`echo $line | cut -f1 -d';'`
    choice1=`echo $line | cut -f2 -d';'`
    choice2=`echo $line | cut -f3 -d';'`
    choice3=`echo $line | cut -f4 -d';'`
    solution=`echo $line | cut -f5 -d';'`

    # print question & choices
    slow "$question
    1: $choice1
    2: $choice2
    3: $choice3
1, 2, 3?: "

    # read player choice
    read -t .1 -n 100 buf
    stty echo
    if [[ -z $buf ]]; then buf=""; else buf="-i $buf"; fi;
    read -t 10 -e $buf -p " " player_choice
    stty -echo

    # compare player against solution & increment score
    if [ "$player_choice" == "" ]
    then
        echo
        slow "Du var för seg!"
    else
    if [ "$player_choice" == "$solution" ]
    then
        score=$(( ++score ))
        slow "Rätt svar!"
    else
        slow "Feeeel"
    fi
    fi

    echo
    sleep 2
    clear
done 9< $quiz_file

# print score
slow "Poäng $score/$QCOUNT"
echo

if [ "$score" == "$QCOUNT" ]
then
    slow "Grattis! Du har klarat quizet!"
    sleep 2
    stty echo
    eject > /dev/null 2>&1
    cmatrix
    killall mpg123
else
    slow "Uh va dåligt, försök igen."
    sleep 1
    clear
fi
}


clear
echo
killall mpg123
mpg123 -l 0 ~/musik.mp3 > /dev/null 2>&1 &
printf "$GREEN%s%*s\n" 
read -p "    Tryck Enter för att starta... " player_choice
stty -echo
clear
<<<<<<< HEAD
mpg123 ~/musik.mp3 > /dev/null 2>&1 &
=======
killall mpg123
mpg123 -l 0 ~/musik.mp3 > /dev/null 2>&1 &
>>>>>>> 40379e3 (Fixed some mpg123 stuff)
reset='\033[0m'
BG='\033[47m'
FG='\033[0;30m'
text="LET ME OUT! LET ME OUT! LET ME OUT! LET ME OUT! LET ME OUT! LET ME OUT! LET ME OUT! LET ME OUT! "
cols=$(tput cols)
# Left Aligned
x=$((cols-${#text}))
x_center=$(((${#text}+cols)/2))
x_rest=$((cols-x_center))
for i in {1..60}
do
    #printf "$FG$BG%s%*s$reset\n" "$text" $x
    printf "$FG$BG%*s%*s$reset\n" $x_center "$text" $x_rest
    sleep 0.01
done
clear

while [ "$score" -lt "$QCOUNT" ]
do
 quiz
done
