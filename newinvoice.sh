#/bin/bash

#############################
#   add invoice component   #
############################

path=`dirname $(realpath $0)`

index=$(cat $path/index.txt)
vatVal=$(cat $path/vat.txt)
# Getting user prompt
echo    ╔═══════════════════════════════════════════════════════╗
echo   '║                  ADDING A NEW INVOICE                 ║'
echo    ╚═══════════════════════════════════════════════════════╝
echo    ┌──────────────────┬────────────────────────────────────┐
read -p '│ Company name:    │ ' customername
echo    ├──────────────────┼────────────────────────────────────┤
read -p '│ Type of mission: │ ' missiontype
echo    ├──────────────────┼────────────────────────────────────┤
read -p '│ Contract price:  │ ' price
echo    ├──────────────────┼────────────────────────────────────┤
read -p '│ Payment duee:    │ ' dl
echo    ├──────────────────┼────────────────────────────────────┤
read -p '│ VAT? (y/n):      │ ' isVat
echo    └──────────────────┴────────────────────────────────────┘
		
# Include VAT if needed
case ${isVat,,} in
	y)	
	# Compute variables		
		vatAdded=`echo "$vatVal * $price" | bc`
		vat=`echo "$vatAdded - $price" | bc`
		echo ""
	# Display the computed infos

		echo '╓──────────────────┬────────────────────────────────────┐'
		echo '║ The VAT value is │' $vat  
		echo '║──────────────────┼────────────────────────────────────┤'
		echo '║ Full price is    │' $vatAdded 
		echo '║──────────────────┼────────────────────────────────────┤'
		;;
	n)
		vatAdded=$price
		vat=""
		echo '╓──────────────────┬────────────────────────────────────┐'
		echo '║ Full price is    │' $vatAdded 
		echo '║──────────────────┼────────────────────────────────────┤'
		;;
	*)
		echo ""
		echo Wrong input
		;;
	esac

# Increment the index value
((index=index+1))
echo $index > $path/index.txt

# Add the infos at the bottom of the db file
numinv=$($path/numgen.sh)
echo '║ Invoice ref.     │' $numinv
echo '║──────────────────┴────────────────────────────────────┤'
echo '│'\!$index\!'│'\!${customername^^}\!'│'\!${missiontype^^}\!'│'\!$price\!'│'\!$vatAdded\!'│'\!$vat\!'│'\!$numinv\!'│'\!$dl >> $path/invoicesdb.csv
echo '║ Invoice added successfully!                           │'
echo '╙───────────────────────────────────────────────────────┘'
