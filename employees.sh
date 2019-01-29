#!/bin/bash

#----------------- Variables ---------------------------------------------------------------------
boldgreen="\033[1;32m"
flashred="\033[5;31m"
normal="\033[0m"
myfile=".database.txt"


#----------------- Functions ---------------------------------------------------------------------
function line {
	if [ $1 -eq 1 ]; then
		echo "------------------------------------------------"
	fi
	if [ $1 -eq 2 ]; then
		echo "--------------------------------------------------------------------------------------"
	fi
}

function wait {
	echo -en $boldgreen"\n $1 \n"$normal
	read dummy
}

function asking {
	read -p " $1" item
	echo $item
}
function spin {
	echo -ne " $1 "
	for loop in seq{1..10}; do
		echo -n "."
		sleep 0.5
	done
	echo
}


#----------------- Variables ---------------------------------------------------------------------

# If banner is installed then display logo
if [ -e /usr/bin/banner ]; then
	clear
	echo
	banner " EMPLOYEES"
	banner " DATABASE"
	banner " Ver 1.00"
	spin "\n\n\t"
fi

while true; do
	clear
	echo -e $boldgreen"\n Main Menu"
	echo -e " =========\n"$normal
	echo " 1. New Record"
	echo " 2. View Records"
	echo " 3. Update Records"
	echo " 4. Quit Program"
	echo -en "\n Enter your choice [1-4]: "
	read choice
	
	case $choice in
		1)
			while true; do
				clear
				echo -e $boldgreen"\n New Record Section"
				echo -e " ==================\n"$normal
				echo " Enter the following information"
				line 1
				pno=$(asking "Personal No    : ")
				ename=$(asking "Employee Name  : ")
				desig=$(asking "Designation    : ")
				addr=$(asking "Address        : ")
				cont=$(asking "Contact Number : ")
				line 1
				while [[ ! $selection = [Yy] || ! $selection = [Nn] ]]; do
					selection=$(asking "Is the information correct [Y-N] :")
					case $selection in
						[Yy])	
								echo "$pno:$ename:$desig:$addr:$cont" >> $myfile
								echo -e "\n\n"
								spin $boldgreen"Saving data"$normal
								break
								;;
						[Nn])
								wait "Data will not be saved. Press"$flashred" <ENTER> "$normal$boldgreen"to proceed..."$normal
								break
								;;
						*)
							wait "Wrong selection, select [Y-N] only. Press"$flashred" <ENTER> "$normal$boldgreen"to try again..."$normal
							;;
					esac			
				done
				echo
				try=$(asking "Press [M] for Main Menu : ")
				if [[ $try = [Mm] ]]; then
					break
				fi
			done	
			;;
		2)
			clear
			wait "Instructions\n ============\n\n"$normal" 1. To see more record in Preview Press <ENTER> on each page.\n 2. To quit Preview Press [Q] at the end.\n\n\n Press <ENTER> to proceed..."
			clear
			(line 2; sort $myfile | awk -F ":" '{printf "%-10s %-30s %-20s \n%10s %-50s %20s\n--------------------------------------------------------------------------------------\n", $1, $2, $3," ", $4, $5}') | less
			;;
		3)
			clear
			line 1
			echo " Record Updating Section"
			line 1
			pno=$(asking "Enter Personal No : ")
			pnum=$(awk -F ":" '{print $1}' $myfile | grep "$pno")
			line 1
			spin $boldgreen"Please wait "$normal

			if [[ $pno = $pnum ]]; then
				pno=$(grep "$pnum" $myfile | awk -F ":" '{print $1}')
				ename=$(grep "$pnum" $myfile | awk -F ":" '{print $2}')
				desig=$(grep "$pnum" $myfile | awk -F ":" '{print $3}')
				addr=$(grep "$pnum" $myfile | awk -F ":" '{print $4}')
				cont=$(grep "$pnum" $myfile | awk -F ":" '{print $5}')
				while true; do
					clear
					line 1
					echo -e $boldgreen" Selected Record"$normal
					line 1
					echo " <1> Personal No   : $pno"
					echo " <2> Employee Name : $ename"
					echo " <3> Designation   : $desig"
					echo " <4> Address       : $addr"
					echo " <5> Contact Number: $cont"
					line 1
					echo -e $boldgreen" Options"$normal
					line 1
					echo " [6] Edit Record "
					echo " [7] Delete Record"
					echo " [8] Back to Main Menu"
					line 1
					choice=$(asking "What do you want? [6-8] : ")
					case $choice in
						6)
						# Editing the Record
							line 1
							select=$(asking "Select Field to Edit [1-5] : ")
							case $select in
								1)  previous=$pno
									recno=1	
									;;
								2) 	previous=$ename
									recno=2
									;;
								3)	previous=$desig
									recno=3
									;;
								4)
									previous=$addr
									recno=4
									;;	
								5)	previous=$cont
									recno=5
									;;
							esac
							line 1
							echo " Previous Value : $previous"
							current=$(asking "Current Value  : ")
							case $recno in
								1)	pno=$current;;
								2)	ename=$current;;
								3)	desig=$current;;
								4) 	addr=$current;;
								5)	cont=$current;;
							esac
							echo "$pno:$ename:$desig:$addr:$cont" > temp.txt
							grep -v "$pnum" $myfile >> temp.txt
							sort temp.txt > $myfile
							rm temp.txt
							;;
						7)
							line 1
							confirm=$(asking "Are you sure to delete record [Y] : ")
							if [[ $confirm = [Yy] ]]; then
								grep -v "$pnum" $myfile > temp.txt
								sort temp.txt > $myfile
								rm temp.txt
								clear
								line 2
								wait "Record has been deleted. Press"$flashred" <ENTER> "$normal$boldgreen"to proceed..."
								break
							fi
							;;
						8)
							break;;
						*)
							wait "Wrong selection, select only [5-7], Press"$flashred" <ENTER> "$normal$boldgreen"to proceed..."	
							;;
					esac
				done
			else
				line 2
				echo " Sorry No record of Personal No.$pno found in the database"
				line 2
				wait "Press "$flashred"<ENTER>"$normal$boldgreen" to proceed..."
			fi
			;;
		4)
			clear
			echo -e $boldgreen"\n Allah Hafiz\n"$normal
			break
			;;
		*)
			wait "Wrong choice, select [1-4] only. Press"$flashred" <ENTER> "$normal$boldgreen"to proceed..."$normal
			;;
	esac
done