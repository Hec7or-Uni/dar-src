#!/bin/sh

# SETUP PCB2

#Direccionamiento permanente
sudo tee /opt/bootlocal.sh << EOF
#!/bin/sh
sudo /opt/eth0.sh&
EOF

sudo chmod u+x /opt/bootlocal.sh

sudo tee /opt/eth0.sh << EOF
#!/bin/sh
pkill udhcpc
ip -4 addr add 192.168.20.2/24 broadcast 192.168.20.255 dev eth0
EOF

sudo chmod u+x /opt/eth0.sh

sudo filetool.sh -b

sudo /opt/bootlocal.sh

ip route add 0.0.0.0/0 via 192.168.20.3
