#!/bin/sh

# SETUP PCB3

service zebra stop
service ripd stop

ifdown eth0
ifup eth0

ifdown eth1
ifup eth1

ip -4 addr add 192.168.20.3/24 broadcast 192.168.20.255 dev eth0

ip -4 addr add 192.168.7.20/24 broadcast 192.168.7.255 dev eth1

sysctl -w net.ipv4.ip_forward=1

ip -4 link set eth0 mtu 1500
ip -4 link set eth1 mtu 1500







radvd.conf
interface eth0
{
        AdvSendAdvert on;
        MinRtrAdvInterval 30;
        MaxRtrAdvInterval 100;
        prefix 2000:A::/64
        {
                AdvOnLink on;
                AdvAutonomous on;
                AdvRouterAddr off;
        };

};


