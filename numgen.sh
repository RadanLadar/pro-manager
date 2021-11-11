#/bin/bash

# Generates invoices number

path=`dirname $(realpath $0)`

month=`date +"%m"`
#read -p 'verif ' month
day=`date +"%d"`
year=`date +"%g"`
quarter="Q"
q1=$(cat $path/q1.txt)
q2=$(cat $path/q2.txt)
q3=$(cat $path/q3.txt)
q4=$(cat $path/q4.txt)


if [ $month -le 3 ]
then
	mvar=1
	((id=$q1+1))
       	echo $id > $path/q1.txt
elif [[ $month -gt 3 && $month -le 6 ]] 
then
	mvar=2
	((id=$q2+1))
       	echo $id > $path/q2.txt
elif [[ $month -gt 6 && $month -le 9 ]]
then
	mvar=3
	((id=$q3+1))
        echo $id > $path/q3.txt
else
	mvar=4
	((id=$q4+1))
       	echo $id > $path/q4.txt
fi

# manage the 000 format
if [[ $id -lt 10 ]]
then
	zornoz="00"
elif [[ $id -ge 10 && $id -lt 99  ]]
then
	zornoz="0"
else
	zornoz=""
fi

echo $year$quarter$mvar$zornoz$id




