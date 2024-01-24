#!/bin/sh

# SETUP PCA3

ip -4 addr add 192.168.10.3/24 broadcast 192.168.20.255 dev eth0

#ip -4 addr add 192.168.7.10/24 dev eth1

sysctl -w net.ipv4.ip_forward=1

ip route add 192.168.20.0/24 via 192.168.7.20

#Direccionamiento dinamico
tee /etc/quagga/zebra.conf > /dev/null << EOF
hostname Router
password zebra
enable password zebra

interface eth1
no shutdown
ip address 192.168.7.10/24
EOF

tee /etc/quagga/ripd.conf > /dev/null << EOF
hostname ripd
password zebra

router rip

network eth0
network eth1
EOF

service zebra start
service ripd start
