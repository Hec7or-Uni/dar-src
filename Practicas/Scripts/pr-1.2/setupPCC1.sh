#!/bin/sh

# SETUP PCC1

service zebra stop
service ripd stop

ifdown eth0
ifup eth0

ip -4 addr add 192.168.7.1/24 broadcast 192.168.7.255 dev eth0

ip route add 0.0.0.0/0 via 192.168.7.3