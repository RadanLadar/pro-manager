#/bin/bash

# GET THE TIME AND DATE, DISPLAY A MESSAGE WHEN A SETUP DATE HAS PASSED

# pqth setup
path=`dirname $(realpath $0)`

# get the day and monthE
day=`date +%d`
month=`date +%m`

# get the deadline 
dl=$(cat $path/dl.txt)

if [[ $dl != ""  ]]
then
	# gap setup
	gap=$(($day - $dl))

	if [[ $day -ge $dl ]]
	then
		echo The deadline for the month  $month has arrived
		if [[ $day != $dl ]]
		then
			echo "${gap} day(s) late!"
		fi
	fi
else
	exit
fi

