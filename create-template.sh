#!/bin/bash

# Author: Alexander Arutyunov (buldezir@gmail.com) github.com/buldezir

if [ ! $1 ]; then
    echo "usage: ./create-template.sh <image>"
    exit 1
fi

if [ ! -e $1 ]; then
    echo "error: $1 does not exist"
    exit 1
fi

vmimage=$1

read -p "Enter VM ID: " vmid

qm status $vmid >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "VM $vmid already exist"
    exit 1
fi

echo "Select Storage Label:"
arr=($(pvesm status --enabled --content=images | awk -F" " '{print $1}' | tail -n +2))
select storage in "${arr[@]}"; do
    read -p "Enter VM Name: " vmname

    echo "Creating VM $vmid with name \"$vmname\" and storage \"$storage\""

    qm create $vmid --name $vmname --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-single
    qm importdisk $vmid $vmimage $storage
    qm set $vmid --scsi0 "$storage:vm-$vmid-disk-0,discard=on,iothread=1,ssd=1"
    qm set $vmid --ide2 "$storage:cloudinit"
    qm set $vmid --boot c --bootdisk scsi0
    qm set $vmid --agent enabled=1
    qm set $vmid --serial0 socket --vga serial0
    qm set $vmid --ipconfig0 ip=dhcp
    qm resize $vmid scsi0 +8G
    qm template $vmid

    exit 0
done

exit 1
