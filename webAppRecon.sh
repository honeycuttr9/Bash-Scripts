#!/bin/bash
echo "Enter url "
read url

ip=$(host $url | awk '/has address/ { print $4 ; exit }')
echo "Running Web App Recon Against $ip"
whois $url > whois.txt
dns_servers =$(dig +short $url | awk '{ print ; exit } ')
dig ns $url > digNS.txt
dig axfr $url $dns_servers
theHarvester -b all -d $ip > theHarvester.txt

while true; do

echo "1 = version and OS scan"
echo "2 = http-waf-detect scan port 80, 443, 8080, and 8081" 
echo "3 = script=http-waf-fingerprint port 80 and 443"
echo "4 = ssl-enum-ciphers port 443"
echo "5 = exit"

echo -n "Enter what nmap script to run: " 
read script

case $script in 
1) 
sudo nmap -sV -O $ip > nmapVersionAndOS.txt
;;

2)
sudo nmap -p 80,443,8080,8081 --script=http-waf-detect $ip > nmapWAFDetect.txt
;;

3)
sudo nmap -sT -sV -p 80,443 --script=http-waf-fingerprint $ip > nmapWAFFingerprint.txt
;;

4)
sudo nmap -sT -p 443 --script ssl-enum-ciphers $ip > nmapSSLEnumCiphers.txt
;;

5) 
break 
;;
esac 
done

sslscan $ip > sslScan.txt
wafw00f $ip > wafw00.txt

name = testssl
dpkg -s $name &> /dev/null

if [ $? -ne 0 ]
  then 
    echo "not installed"
    sudo apt-get update
    sudo apt-get install $name
  else 
    echo "testssl is installed"
    testssl $ip > testSSL.txt
fi

curl "$url/robots.txt" > robots.txt
