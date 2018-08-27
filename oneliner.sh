#!/bin/bash
# oneliner example

IFS=$'\n';pattern="contact_groups L2, L1" && |\
for i in $(cat /usr/share/nagvis-2/etc/maps/Main.cfg |\
grep description= | cut -d= -f2); \
do for j in $(grep -rnw /etc/nagios/hosts/ -e "$i"| cut -d: -f1);do \
if [[ -z $(grep $pattern $j) ]] ; \
then sed -i "/$i/a \\\t$pattern" $j; fi ;done; done;
 
# and with explanation
 
# replace space delimiter with EOL delimiter on "for" loop
IFS=$'\n'; 
# define string to insert
pattern="contact_groups L2, L1"; 
# find all service descriptions from nagvis configs
for i in $(cat /usr/share/nagvis-2/etc/maps/Main.cfg  | grep description= | cut -d= -f2); do 
# find all nagios configs containing service description needed
    for j in $(grep -rnw /etc/nagios/hosts/ -e "$i"| cut -d: -f1); do 
# check if string is not already inserted earlier
        if [[ -z $(grep $pattern $j) ]] ; then 
# insert string after string, containing service description
            sed -i "/$i/a \\\t$pattern" $j; 
        fi;
    done; 
done;
