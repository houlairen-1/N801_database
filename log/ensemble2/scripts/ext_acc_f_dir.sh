#!/bin/sh
##$1 dir
##$2 embedding rate

all_subdir=`ls $1 |grep "_C"$`

for (( er=10; er<=50; er=er+10 ))
do
    #    echo $er
    for subdir in $all_subdir
    do
	dir=$1$subdir'/'
        #    echo $dir
	all_file=`ls $dir |grep "_${er}_"`
	# echo $all_file
	for file in $all_file
	do
	    accuracy=`cat $dir$file |grep 'splits:' |cut -d ':' -f 2 |cut -d ' ' -f 2`
	    echo -en $accuracy'\t'
	done
	echo ''
    done
done