#!/bin/bash

#generate random number
pass=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c14)
echo "New 14 character long password is:" $pass 

#scan ip or website
read -p "Enter a website or IP address: " target
for i in {1..1000};
do 
  timeout 1 bash -c "</dev/tcp/$target/$i &>/dev/null" &&  echo "port $target is open"
done
