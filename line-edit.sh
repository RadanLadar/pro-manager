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
lineid="${line%%!*}"
invoicenum="${line##*!}"
oldname=$(echo $line | cut -d '!' -f2 )
oldtype=$(echo $line | cut -d '!' -f3 )
oldprice=$(echo $line | cut -d '!' -f4 )
oldvalue=$(echo $line | cut -d '!' -f5 )
oldvat=$(echo $line | cut -d '!' -f6 )

# Get input for data update

read -p "New NAME ($oldname) " name
read -p "New TYPE ($oldtype) " missiontype
read -p "New PRICE ($oldprice) " price

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

sed "${_id}s/.*/$lineid\!$newname\!$newtype\!$newprice\!$newvalue\!$newvat\!$invoicenum/" $path/invoicesdb.csv > $path/tempdb.csv

# replace the old file with the new one
mv $path/invoicesdb.csv $path/invoices.old.csv
mv $path/tempdb.csv $path/invoicesdb.csv

