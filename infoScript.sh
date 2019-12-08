#!/bin/bash

#Function to display menus
show_menus() {
date
echo "------------------------------"
echo "Main Menu"
echo "------------------------------"
echo "1. Operating System Info"
echo "2. Hostname and DNS Info"
echo "3. Network Info"
echo "4. Who Is Logged In"
echo "5. Last Logged In User"
echo "6. Free and Used Memory Info"
echo "7. Get My IP"
echo "8. My Disk Usage"
echo "9. Process Usage"
echo "10. Hardware Info"
echo "11. Exit" 
}

#read input from user
read_options(){
  local choice
  read -p "Enter your choice [ 1 - 11 ] " choice
  case $choice in 
    1) echo "System Info: " $(uname -a) ;; 
    2) echo "Hostname..." 
       uname -n
       echo "DNS Info..." 
       cat /etc/resolv.conf ;; 
    3) echo "Interface Config..." 
       ifconfig -a ;; 
    4) echo "Logged In User Info..." 
       w
       echo "Checking Last 5 Entries in /var/log/auth.log..."
       sudo head -5 /var/log/auth.log ;; 
    5) echo "Checking Last 5 Logged in Users..."
       last | head -5 ;;
    6) echo "Memory in megabytes..." 
       free -m;;
    7) echo "Getting IP..."
       curl ifconfig.me 
       echo ;;
    8) echo "Displaying Disk Usage..."
       df ;;
    9) echo "Displaying Process Usage..."
       #htop 
       #nmon if supported
       #add if statement
       iostat 
       ;;
    10) echo "Hardware Info..." 
        sudo lshw -short
        echo "Storage Device Info..." 
        lsblk ;;
    11) exit 0;; 
  esac
}

while true
do 
  show_menus
  read_options
done




























