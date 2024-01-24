#!/bin/sh

# SETUP PCC1

tee /etc/quagga/zebra.conf > /dev/null << EOF
hostname Router
password zebra
enable password zebra

interface eth0
no shutdown
ip address 192.168.7.1/24
EOF
#Para el ej 3
#ip route 0.0.0.0/0 192.168.7.10
#EOF

tee /etc/quagga/ripd.conf > /dev/null << EOF
hostname ripd
password zebra

router rip

network eth0
EOF

service zebra start
service ripd start
