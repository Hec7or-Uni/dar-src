# Práctica 3.1
#### Diseño y Administración de Redes
##### Ingeniería informática 2022 - 2023

|**Autores**|**NIP** | 
|:----------|-|
| Toral Pallás, Héctor | 798095 |
| Lahoz Bernad, Fernando | 800989 |
| Martínez Lahoz, Sergio | 801621 |

## Configuración del escenario

### Configuración de las VLAN en C3725-1 y C3725-2

Dentro del switch creamos las VLAN 2 y 3:

```bash
vlan database
vlan 2
vlan 3
exit
```

Asignamos el puerto fast ethernet 2/0 a la VLAN 2 y el puerto 2/1 a la VLAN 3, ambas untagged:

```bash
configure terminal
interface FastEthernet 2/0
switchport mode access
switchport access vlan 2

interface FastEthernet 2/1
switchport mode access
switchport access vlan 3
exit
write
```

---

Asignamos el puerto 2/15 para que haga de enlace entre ambos switch:

```bash
configure terminal
interface FastEthernet 2/15
switchport mode trunk
vlan-range dot1q 2 3
exit
```

```bash
write
```

---

```bash
c3725-1#show vlan-switch

VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    Fa2/2, Fa2/3, Fa2/4, Fa2/5
                                                Fa2/6, Fa2/7, Fa2/8, Fa2/9
                                                Fa2/10, Fa2/11, Fa2/12, Fa2/13
                                                Fa2/14, Fa2/15
2    VLAN0002                         active    Fa2/0
3    VLAN0003                         active    Fa2/1
1002 fddi-default                     active
1003 token-ring-default               active
1004 fddinet-default                  active
1005 trnet-default                    active

VLAN Type  SAID       MTU   Parent RingNo BridgeNo Stp  BrdgMode Trans1 Trans2
---- ----- ---------- ----- ------ ------ -------- ---- -------- ------ ------
1    enet  100001     1500  -      -      -        -    -        1002   1003
2    enet  100002     1500  -      -      -        -    -        0      0
3    enet  100003     1500  -      -      -        -    -        0      0
1002 fddi  101002     1500  -      -      -        -    -        1      1003
1003 tr    101003     1500  1005   0      -        -    srb      1      1002
1004 fdnet 101004     1500  -      -      1        ibm  -        0      0
1005 trnet 101005     1500  -      -      1        ibm  -        0      0
```

```bash
c3725-1#show vlan-range
IDB-less VLAN Ranges on FastEthernet2/15 (1 ranges)
2-3                                     (range)
```

### Configuración de C3725-2 como router

```bash
c3725-2#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
FastEthernet0/0            unassigned      YES unset  administratively down down
FastEthernet0/1            unassigned      YES unset  administratively down down
Serial1/0                  unassigned      YES unset  administratively down down
Serial1/1                  unassigned      YES unset  administratively down down
Serial1/2                  unassigned      YES unset  administratively down down
Serial1/3                  unassigned      YES unset  administratively down down
FastEthernet2/0            unassigned      YES unset  up                    up
FastEthernet2/1            unassigned      YES unset  up                    up
FastEthernet2/2            unassigned      YES unset  up                    down
FastEthernet2/3            unassigned      YES unset  up                    down
FastEthernet2/4            unassigned      YES unset  up                    down
FastEthernet2/5            unassigned      YES unset  up                    down
FastEthernet2/6            unassigned      YES unset  up                    down
FastEthernet2/7            unassigned      YES unset  up                    down
FastEthernet2/8            unassigned      YES unset  up                    down
FastEthernet2/9            unassigned      YES unset  up                    down
FastEthernet2/10           unassigned      YES unset  up                    down
FastEthernet2/11           unassigned      YES unset  up                    down
FastEthernet2/12           unassigned      YES unset  up                    down
FastEthernet2/13           unassigned      YES unset  up                    down
FastEthernet2/14           unassigned      YES unset  up                    down
FastEthernet2/15           unassigned      YES unset  up                    down
Vlan1                      unassigned      YES unset  up                    down
```

Asignamos las direcciones IP a cada VLAN:

```bash
configure terminal
interface vlan 2
ip address 192.168.2.254 255.255.255.0
exit
```

```bash
interface vlan 3
ip address 192.168.3.254 255.255.255.0
exit
```

```bash
ip routing
end
write
```

```bash
c3725-2#show ip interface brief
Interface                  IP-Address      OK? Method Status                Protocol
FastEthernet0/0            unassigned      YES unset  administratively down down
FastEthernet0/1            unassigned      YES unset  administratively down down
Serial1/0                  unassigned      YES unset  administratively down down
Serial1/1                  unassigned      YES unset  administratively down down
Serial1/2                  unassigned      YES unset  administratively down down
Serial1/3                  unassigned      YES unset  administratively down down
FastEthernet2/0            unassigned      YES unset  up                    up
FastEthernet2/1            unassigned      YES unset  up                    up
FastEthernet2/2            unassigned      YES unset  up                    down
FastEthernet2/3            unassigned      YES unset  up                    down
FastEthernet2/4            unassigned      YES unset  up                    down
FastEthernet2/5            unassigned      YES unset  up                    down
FastEthernet2/6            unassigned      YES unset  up                    down
FastEthernet2/7            unassigned      YES unset  up                    down
FastEthernet2/8            unassigned      YES unset  up                    down
FastEthernet2/9            unassigned      YES unset  up                    down
FastEthernet2/10           unassigned      YES unset  up                    down
FastEthernet2/11           unassigned      YES unset  up                    down
FastEthernet2/12           unassigned      YES unset  up                    down
FastEthernet2/13           unassigned      YES unset  up                    down
FastEthernet2/14           unassigned      YES unset  up                    down
FastEthernet2/15           unassigned      YES unset  up                    down
Vlan1                      unassigned      YES unset  up                    down
Vlan2                      192.168.2.254   YES manual up                    up
Vlan3                      192.168.3.254   YES manual up                    up
```

### Asignación de direcciones IP a las máquinas

#### LAN A
##### PC1

```bash
ip 192.168.2.1 netmask 255.255.255.0 192.168.2.254
show ip
save
```

##### PC2

```bash
ip 192.168.3.2 netmask 255.255.255.0 192.168.3.254
show ip
save
```

---

#### LAN B

##### PC3

```bash
ip 192.168.2.3 netmask 255.255.255.0 192.168.2.254
show ip
save
```

##### PC4

```bash
ip 192.168.3.4 netmask 255.255.255.0 192.168.3.254
show ip
save
```

## Comprobación de funcionamiento

Ejecutando un ping de PC1 a PC2 observamos que hay conexión. Se han realizado dos capturas de red: una en el enlace que conecta PC1 y C3725-1 (s1) y otra en el que conecta ambos switches (s2).

Observamos el paquete 37 de la captura s1 y 114 de s2: podemos comprobar que es la misma conexión a partir del identificador a nivel IP (0xf072). Las direcciones IP de origen y destino son la de PC1 y PC2, y la MAC origen corresponde a la de PC1, pero la MAC destino no corresponde a PC2, sino a C3725-2. También podemos ver que el campo tipo en la cabecera ethernet de s1 es IPv4, mientras que en s2 ha sido sustituido por los 4 bytes de Virtual LAN, lo que confirma que ese puerto es tagged. El campo id de Virtual LAN indica que se trata de un mensaje enviado desde la VLAN 2.

Como las máquinas pertenecen a dos VLAN distintas, es necesario que haya encaminamiento. El paquete 115 de s2 es el mismo ICMP request anterior, pero en la VLAN 3 (campo type ethernet). Podemos ver que el campo TTL ha cambiado: el de la VLAN 2 tiene TTL 64 y el de la VLAN 3 tiene TTL 63, indicando que ha pasado por un encaminador. La dirección MAC origen es ahora la del encaminador, y la de destino ya corresponde a la de PC2.

El último enlace por el que pasaría el mensaje request sería el que une PC2 y C3725-1, pero no tenemos una captura que lo compruebe. En ella se debería ver el paquete correspondiente sin campo Virtual LAN en ethernet, sólo los 2 bytes de tipo, con valor TTL 63 y las mismas direcciones IP y MAC que el paquete 115 de s2.

![Esquema de la comunicación](https://github.com/Hec7or-Uni/dar-pr/blob/main/scripts/pr3/pr3_1_P13.svg)

En las capturas también se pueden ver los mensajes ARP necesarios para obtener las direcciones MAC. En la captura s1 nos interesan 2 paquetes: 12 y 18. El primero es un mensaje ARP del router anunciando su MAC (la ip origen es 192.168.2.254), y por ello PC1 es capaz de enviar un primer request sin preguntar por la MAC destino. Como el router no ha recibido ninguna pregunta ARP, no sabe la MAC de PC1, por lo que envía el segundo. El ICMP request en este caso corresponde a un ping entre PC1 y el router, pero el comportamiento si el ping fuera entre PC1 y PC2 sería el mismo. En la captura s2 vemos también el anuncio ARP, esta vez en ambas VLAN (paquetes 48 y 50). Aún así, el router sigue sin saber la MAC de PC2, por lo que se ve obligado a preguntar en el paquete 66.

