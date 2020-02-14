#!/bin/bash
echo "Enter url like google.com, facebook.com, etc..."
read url

ip=$(host $url | awk '/has address/ { print $4 ; exit }')
echo "Running Web App Recon Against $ip"

echo "Running whois"
whois $url > whois.txt

echo "Running dig"
dig +short NS $url > dns_servers.txt
dig ns $url > dig.txt
cat dns_servers.txt | while read i; do
  dig axfr $url $i >> dig.txt
done

echo "Running theHarvester"
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

echo "Running SSL Scan"
pkgs='sslscan'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
  sudo apt-get install $pkgs
fi
sslscan $ip > sslScan.txt

echo "Running wafw00f Scan"
pkgs='wafw00f '
if ! dpkg -s $pkgs >/dev/null 2>&1; then
  sudo apt-get install $pkgs
fi
wafw00f $ip > wafw00f.txt

pkgs='testssl.sh '
if ! dpkg -s $pkgs >/dev/null 2>&1; then
  sudo apt-get install $pkgs
fi
testssl $ip > testSSL.txt

curl "$url/robots.txt" > robots.txt
