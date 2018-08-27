#!/bin/bash
# nagios check if ip changed uder URL

if [ "$1" == "" ] || [ "$2" == "" ]
then
        echo "usage: Check_ip_url.sh url ip"
        exit 0
fi
is_true=$(ping -c 1 $1 | awk '{print $3}' | awk 'FNR <=1 {print}' | tr -d "(,)")
if [ "$is_true" == $2 ]
then
        echo "OK"
        exit 0
else
        echo "Critical"
        exit 2
fi
