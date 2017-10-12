#!/bin/sh
##$1 dir
##$2 embedding rate

for (( er=10; er<=50; er=er+10 ))
do
    dir=$1
    all_file=`ls $dir |grep "_${er}_"`
    for file in $all_file
    do
	accuracy=`cat $dir$file |grep 'splits:' |cut -d ':' -f 2 |cut -d ' ' -f 2`
	echo -en $accuracy'\t'
    done
    echo ''
done