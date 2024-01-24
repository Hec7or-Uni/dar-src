#!/bin/sh

# IPTABLES PCA1

#flush
iptables -F

iptables -t nat -A POSTROUTING -o eth0 -p tcp --dport 22 -j SNAT --to 192.168.10.1:2016
