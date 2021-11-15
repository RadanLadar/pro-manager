#/bin/bash

# line edit feature

# setup path
path=`dirname $(realpath $0)`

# import VAT value
vatVal=$(cat $path/vat.txt)

# first prompt
read -p 'Which line do you want to edit? ' id

# id correction for request
_id=$((id + 1))

# get the required line 
line=$(sed "${_id}!d" $path/invoicesdb.csv)

# turn old data into vars
#lineid="${line%%!*}"
#invoicenum="${line##*!}"
lineid=$(echo $line | cut -d '!' -f2 )
oldname=$(echo $line | cut -d '!' -f4 )
oldtype=$(echo $line | cut -d '!' -f6 )
oldprice=$(echo $line | cut -d '!' -f8 )
oldvalue=$(echo $line | cut -d '!' -f10 )
oldvat=$(echo $line | cut -d '!' -f12 )
invoicenum=$(echo $line | cut -d '!' -f14 )

# Get input for data update
echo '┌───────────────────────────────────────────────────────┐'
read -p "│ New NAME ($oldname) ▒ " name
echo '├───────────────────────────────────────────────────────┤'
read -p "│ New TYPE ($oldtype) ▒ " missiontype
echo '├───────────────────────────────────────────────────────┤'
read -p "│ New PRICE ($oldprice) ▒ " price

echo '├───────────────────────────────────────────────────────┤'
echo '│ Line edited successfully!                             │'
echo '└───────────────────────────────────────────────────────┘'

# process input

# process NAME input
if [[ $name != "" ]]
then
	newname=$name
else
	newname=$oldname
fi

# process TYPE input
if [[ $missiontype != "" ]]
then
	newtype=$missiontype
else
	newtype=$oldtype
fi

# process PRICE input
if [[ $price != "" ]]
then 
	newprice=$price
	newvalue=`echo "$vatVal * $price" | bc`
	newvat=`echo "$newvalue - $price" | bc`
else
	newprice=$oldprice
	newvalue=$oldvalue
	newvat=$oldvat
fi

# write into a temporary file

sed "${_id}s/.*/│\!$lineid\!│\!${newname^^}\!│\!${newtype^^}\!│\!$newprice\!│\!$newvalue\!│\!$newvat\!│\!$invoicenum\!│/" $path/invoicesdb.csv > $path/tempdb.csv

# replace the old file with the new one
mv $path/invoicesdb.csv $path/invoices.old.csv
mv $path/tempdb.csv $path/invoicesdb.csv

