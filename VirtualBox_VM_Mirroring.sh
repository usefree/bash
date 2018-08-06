#!/bin/bash

#---- script for creating the full miror of Virtualbox VM 

datenow=$(date +'%d-%m-%Y')
host2="192.168.0.1"
host1="192.168.0.77"
echo "------------------------------"
echo $datenow
echo "------------------------------"
vmstate=$(VBoxManage showvminfo 2003_1_1 --details | grep State | awk '{print $2}')
hoststate1=$(ping -c 1 $host2 | grep received | awk '{print $4}') 
	if [ "$vmstate" == "powered" ] && [ "$hoststate1" == "1" ]
		then
			echo "$host1 vm state powered off"
			echo "$host2 - > $host1"
			ssh $host2 'VBoxManage controlvm 2003_1_1 poweroff' && \
			VBoxManage storageattach 2003_1_1 --storagectl "IDE Controller" --port 0 --device 0 --medium none && \
			VBoxManage closemedium disk /mnt/epart/vm/2003_1_1/2003-disk1.vmdk && \
			rm -f /mnt/epart/vm/2003_1_1/2003-disk1.vmdk && \
			ssh $host2 'rsync -av -e "ssh -p 222" /mnt/epart/vm/2003_1_1/2003-disk1.vmdk $host1:/mnt/epart/vm/2003_1_1/2003-disk1.vmdk' && \
			VBoxManage storageattach 2003_1_1 --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium /mnt/epart/vm/2003_1_1/2003-disk1.vmdk && \
			VBoxManage startvm 2003_1_1 --type headless && \
			ssh $host2 'datenow=$(date +"%d-%m-%Y") && mkdir /mnt/epart3/b/$datenow' && \
			ssh $host2 'datenow=$(date +"%d-%m-%Y") && rsync -av /mnt/epart/vm/2003_1_1/2003-disk1.vmdk /mnt/epart3/b/$datenow/2003-disk1.vmdk'
		elif [ "$vmstate" == "running" ] && [ "$hoststate1" == "1" ]
		then
			echo "$host2 vm state powered off"
			echo "$host1 - > $host2"
			VBoxManage controlvm 2003_1_1 poweroff && \
			ssh $host2 'VBoxManage storageattach 2003_1_1 --storagectl "IDE Controller" --port 0 --device 0 --medium none' && \
			ssh $host2 'VBoxManage closemedium disk /mnt/epart/vm/2003_1_1/2003-disk1.vmdk' && \
			ssh $host2 'rm -f /mnt/epart/vm/2003_1_1/2003-disk1.vmdk' && \
			rsync -av /mnt/epart/vm/2003_1_1/2003-disk1.vmdk $host2:/mnt/epart/vm/2003_1_1/2003-disk1.vmdk && \
			ssh $host2 'VBoxManage storageattach 2003_1_1 --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium /mnt/epart/vm/2003_1_1/2003-disk1.vmdk' && \
			ssh $host2 'VBoxManage startvm 2003_1_1 --type headless'
		else 
			echo "Unknown machine state or backup host unreachable."
			echo "vmstate: $vmstate; hoststate1: $hoststate1; hoststate2: $hoststate2"
	fi	

# ----------- resize disk
# VBoxManage showhdinfo /mnt/epart/vm/2003_1_1/2003-disk1.vmdk
# vboxmanage clonehd /mnt/epart/vm/2003_1_1/2003-disk1.vmdk /mnt/epart2/b2/temp/2003-disk1.vdi --format vdi
# VBoxManage modifyhd /mnt/epart2/b2/temp/2003-disk1.vdi --resize 177287
# ----------- possible remove old disk before cloning
# VBoxManage clonehd /mnt/epart2/b2/temp/2003-disk1.vdi /mnt/epart/vm/2003_1_1/2003-disk1.vmdk --format vmdk
#