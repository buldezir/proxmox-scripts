#!/bin/bash

# Author: Alexander Arutyunov (buldezir@gmail.com) github.com/buldezir

if [ ! $1 ]; then
    echo "usage: ./virt-update-image <image>"
    exit 1
fi

if [ ! -e $1 ]; then
    echo "error: $1 does not exist"
    exit 1
fi

vmimage=$1

virt-customize -a $vmimage --install qemu-guest-agent,git,zsh,htop,neofetch
# virt-customize -a $vmimage --run-command 'sed -ri "s/^#?\s*PasswordAuthentication\s*yes.*/PasswordAuthentication no/g" /etc/ssh/sshd_config'

virt-sysprep -a $vmimage
virt-sysprep -a $vmimage --enable machine-id
