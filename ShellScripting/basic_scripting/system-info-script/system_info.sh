#!/bin/bash

echo "--------------------------------"
echo "   System Information Script    "
echo "   Date $(date)		      " 
echo "--------------------------------"


echo "Hostname: 	$(hostname)   "
echo "UpTime  :      $(uptime -p)  " 

echo "Logged in as:"
who


echo "CPU Load        : $(top -bn1 | grep "load average" | awk '{print $10 $11 $12}')"
echo "Memory Usage    :"
free -h


echo "Disk Usage:      " 
df -h | grep "^/dev/"

echo "Ip address:	"
hostname -I
