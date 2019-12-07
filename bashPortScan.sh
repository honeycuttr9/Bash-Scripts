#!/usr/bin/env bash

#clear terminal screen 
tput clear
trap ctrl_c INT

#gracefully handle ctrl-c interrupt
function ctrl_c() {
        echo "***You pressed Ctrl+C...Exiting Script Now***;"
	exit 0;
}

#get user input of ip
ip="$1"
echo "---------------------------------"
echo "--------- Running Bash Port Scanner Script ---------"
echo
 
if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] ; then 
	echo "You entered a valid IPv4 address...lets move on:"
	echo
	echo -e "Checking is $ip is up"
	echo
	START=$(date +%s)
	ping -c1 $ip >/dev/null 2>&1
                
                #check that no error occurred 
		if [ "$?" = 0 ] ; then
	        	echo "Host is up"
	        	echo
			read -p "Do you want TCP or UDP port scan:// Just press tcp/udp to continue: " answer
					if [[ $answer = tcp ]]; then
					echo "Now starting to scan the IP address: $ip for open TCP ports  "
	        			echo "-----------------------------------------------------------"
					nc -z -v -w 1 -n $ip 1-10000
					echo
					END=$(date +%s)
					DIFF=$(( $END - $START ))
					echo "Script completed in $DIFF seconds :"
					echo	
				elif [[ $answer = udp ]]; then 
					echo "Now starting to scan the IP address: $ip for open UDP ports  "
	        			echo "-----------------------------------------------------------"
					nc -vz -u -w 1 $ip 20-443
					echo
					END=$(date +%s)
					DIFF=$(( $END - $START ))
					echo "Script completed in $DIFF seconds :"
				else 
					echo "Exiting...Run the script again and type tcp or udp"
				fi
		echo
	
		else
			echo "Host seems to be down....exiting"
		fi
else
	echo "Exiting.....Enter a valid IPv4 address: "


fi


exit 0;

