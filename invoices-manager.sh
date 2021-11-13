#/bin/bash

# ---------INFO---------
# Invoices management script
# github.com/RadanLadar/pro-manager

# -----DEPENDENCIES-----
# -bc ; floating-numbers computing
# -figlet ; header txt

# -------- TODO---------
# - Check for improvements

# GITHUB CONNECT CHECK

# Setup path
path=`dirname $(realpath $0)`

# User prompt init
choice=""

# Clear the terminal when the program starts
clear

# Loops to avoid unwanted exits
while [ choice != "q" ]
do # Everything below must be reload for update

# Import VAT value
vatVal=$(cat $path/vat.txt)

# Import deadline
dl=$(cat $path/dl.txt)

# Header
figlet invoice
figlet manager

# Display entry choice
echo ""
cat $path/menu.txt
echo ""

# Import alert script
$path/alert.sh

# Get the choice
read -p 'Your choice: ' choice
echo ---------------------------------------------------------
echo ""
	# Processing the choice
	case ${choice,,} in
		1)
			# Get the index from a file 
			index=$(cat $path/index.txt)
			
			# Getting user prompt
			echo 'ADDING A NEW INVOICE'
			echo ""
			read -p 'Company name: ' customername
			read -p 'Type of mission: ' missiontype
			read -p 'Contract price: ' price
			read -p 'VAT appliable? (y/n): ' isVat
				
				# Include VAT if needed
				case ${isVat,,} in
					y)	
						# Compute variables		
						vatAdded=`echo "$vatVal * $price" | bc`
						vat=`echo "$vatAdded - $price" | bc`
						echo ""
						# Display the computed infos
						echo The VAT value is $vat
						echo Full price is $vatAdded
						;;
					n)
						vatAdded=$price
						vat=""
						echo ""
						echo Full price is $vatAdded
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
			echo The reference of the invoice is $numinv
			echo ""
			echo $index\!${customername^^}\!${missiontype^^}\!$price\!$vatAdded\!$vat\!$numinv >> $path/invoicesdb.csv
			echo Invoice added successfully!
			;;
		# DISPLAY THE FULL LIST
		2)
			echo ""
			echo .......................FULL LIST.............................
			column -t -s '\!' $path/header.csv $path/invoicesdb.csv
			;;
		# SEARCH FEATURE
		3)
			read -p 'Search... ' srcvar
			while IFS= read -r line; do
				if [[ "$line" == *"${srcvar^^}"* ]]; then
					printf '%s\n' "$line" >> $path/srcresult.txt
				fi
			done < $path/invoicesdb.csv 
			
			# Display results
			column -t -s '\!' $path/header.csv $path/srcresult.txt	
			;;
		4)
			$path/line-edit.sh
			;;
		v)
			echo ..........................CONFIG.............................
			echo 1\) VAT value
			echo '---> '$vatVal
			echo ""
			echo 2\) Params
		        echo '---> ' 
			column -t -s '\!' $path/header.csv
			echo ""
			echo 3\) Deadline
			echo '---> '$dl
			echo ""
			echo b\) BACK
			echo ""
			echo _______________
			echo r\) RESET ALL	
			echo ""
			read -p 'Access config num ' conf
				case ${conf,,} in
					1) 
						read -p 'Type your local VAT value (float) ' vatConf
						echo $vatConf > $path/vat.txt
						;;
					2)
						echo This config is not available yet
						;;
					3)
						read -p 'Type the new digits for the deadline date ' dlConf
						echo $dlConf > $path/dl.txt
						;;
					b)
						echo "Back to main menu"
						;;
					r)
						read -p 'Do you really want to erase all data? (y/n) ' reset
						case ${reset,,} in 
							y)
								echo "0" > $path/index.txt
								echo "" > $path/invoicesdb.csv
								echo "000" > $path/q1.txt
								echo "000" > $path/q2.txt
								echo "000" > $path/q3.txt
								echo "000" > $path/q4.txt
								echo "" > $path/dl.txt
								echo All data erased!
								;;
							n)
								echo Aborted!
								;;
							*)
								echo -n 'Wrong input'
								;;
						esac
						;;
					*)
						echo Wrong input
						;;
				esac
			;;
		q)
			clear
			exit
			;;


		*) 

			echo -n 'Wrong choice' 
			;;
	esac

	echo ""
	read -p '(Press any key to continue)'

	# reset research
	echo "" > $path/srcresult.txt
	clear

done
