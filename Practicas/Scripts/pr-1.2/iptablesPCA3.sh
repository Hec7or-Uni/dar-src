#!/bin/sh

# IPTABLES PCA3

#flush
iptables -F

iptables -t nat -A POSTROUTING -o eth1 -j SNAT --to 192.168.7.10