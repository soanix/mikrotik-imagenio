# may/14/2016 00:18:01 by RouterOS 6.35.2
# software id = H1BP-H200
#
/interface ethernet
set [ find default-name=ether1 ] name=ether1-gateway
set [ find default-name=ether2 ] name=ether2-master-local
set [ find default-name=ether3 ] master-port=ether2-master-local name=\
    ether3-slave-local
set [ find default-name=ether4 ] master-port=ether2-master-local name=\
    ether4-slave-local
set [ find default-name=ether5 ] master-port=ether2-master-local name=\
    ether5-slave-local
/interface vlan
add interface=ether1-gateway name=vlan2 vlan-id=2
add interface=ether1-gateway name=vlan3 vlan-id=3
add interface=ether1-gateway name=vlan6 vlan-id=6
/interface pppoe-client
add add-default-route=yes allow=pap,chap disabled=no interface=vlan6 max-mru=\
    1492 max-mtu=1492 name=pppoe-out1 password=adslppp use-peer-dns=yes user=\
    adslppp@telefonicanetpa
/ip dhcp-server option
add code=240 name=option_para_deco value=\
    "':::::239.0.2.10:22222:v6.0:239.0.2.30:22222'"
/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot
/ip pool
add name=dhcp ranges=192.168.1.201-192.168.1.249
add name=vpn ranges=192.168.3.10-192.168.3.20
/ip dhcp-server
add address-pool=dhcp disabled=no interface=ether2-master-local name=dhcp1
/ppp profile
add dns-server=192.168.3.250 local-address=192.168.3.250 name=1 \
    remote-address=vpn
#error exporting /tool user-manager customer
#error exporting /tool user-manager profile
#error exporting /tool user-manager profile limitation
/ip settings
set allow-fast-path=no
/interface pptp-server server
set authentication=mschap2 enabled=yes
/ip address
add address=192.168.1.1/24 interface=ether2-master-local network=192.168.1.0
add address=192.168.100.10/24 interface=ether1-gateway network=192.168.100.0
add address=IPIMAGENIO/10 interface=vlan2 network=10.64.0.0
/ip dhcp-client
add add-default-route=no dhcp-options=hostname,clientid disabled=no \
    interface=vlan3 use-peer-ntp=no
/ip dhcp-server lease
add address=192.168.1.252 client-id=1:94:de:80:81:fa:6e mac-address=\
    94:DE:80:81:FA:6E server=dhcp1
add address=192.168.1.254 client-id=1:1c:6f:65:49:1f:81 mac-address=\
    1C:6F:65:49:1F:81 server=dhcp1
add address=192.168.1.199 client-id="61:72:72:69:73:5f:53:54:49:48:32:30:37:2d\
    :30:2e:30:5f:32:38:33:37:39:38:34:30:32:33:34:30" dhcp-option=\
    option_para_deco mac-address=3C:DF:A9:CA:3E:78 server=dhcp1
/ip dhcp-server network
add address=192.168.1.0/24 dns-server=192.168.1.1 gateway=192.168.1.1 \
    netmask=24
add address=192.168.1.199/32 dhcp-option=option_para_deco gateway=192.168.1.1 \
    netmask=24 next-server=172.26.23.3
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=192.168.1.1 name=router
/ip firewall filter
add action=fasttrack-connection chain=forward
add chain=forward connection-state=established,related
add chain=input protocol=icmp
add chain=input connection-state=established
add chain=input connection-state=related
add chain=forward disabled=yes dst-port=23,80 in-interface=pppoe-out1 \
    protocol=tcp
add chain=input dst-port=8291 in-interface=pppoe-out1 protocol=tcp
add chain=input dst-port=1723 in-interface=pppoe-out1 protocol=tcp
add action=drop chain=input in-interface=pppoe-out1
add chain=forward connection-state=established
add chain=forward connection-state=related
add action=drop chain=forward connection-state=invalid
/ip firewall mangle
add action=set-priority chain=postrouting new-priority=4 out-interface=vlan2
add action=set-priority chain=postrouting new-priority=4 out-interface=vlan3
add action=set-priority chain=postrouting new-priority=1 out-interface=\
    pppoe-out1
/ip firewall nat
add action=masquerade chain=srcnat out-interface=pppoe-out1
add action=masquerade chain=srcnat out-interface=ether1-gateway
add action=masquerade chain=srcnat out-interface=vlan2
add action=masquerade chain=srcnat out-interface=vlan3
add action=dst-nat chain=dstnat dst-address-type=local in-interface=vlan2 \
    to-addresses=192.168.1.199
add action=dst-nat chain=dstnat disabled=yes in-interface=pppoe-out1 \
    protocol=tcp src-port=80 to-addresses=192.168.1.125
add action=dst-nat chain=dstnat disabled=yes in-interface=pppoe-out1 \
    protocol=tcp to-addresses=192.168.1.125
/ip route
add distance=255 gateway=255.255.255.255
/ip upnp
set enabled=yes
/ip upnp interfaces
add interface=ether2-master-local type=internal
add interface=pppoe-out1 type=external
/routing igmp-proxy
set query-interval=15s query-response-interval=2s
/routing igmp-proxy interface
add alternative-subnets=0.0.0.0/0 interface=vlan2 upstream=yes
add interface=ether2-master-local
/routing rip interface
add interface=vlan2 passive=yes receive=v2 send=v1-2
add interface=vlan3 passive=yes receive=v2 send=v1-2
/routing rip network
add network=10.0.0.0/8
add network=172.26.0.0/16
/system clock
set time-zone-name=Europe/Madrid
/system lcd
set contrast=0 enabled=no port=parallel type=24x4
/system lcd page
set time disabled=yes display-time=5s
set resources disabled=yes display-time=5s
set uptime disabled=yes display-time=5s
set packets disabled=yes display-time=5s
set bits disabled=yes display-time=5s
set version disabled=yes display-time=5s
set identity disabled=yes display-time=5s
set pppoe-out1 disabled=yes display-time=5s
set ether1-gateway disabled=yes display-time=5s
set ether2-master-local disabled=yes display-time=5s
set ether3-slave-local disabled=yes display-time=5s
set ether4-slave-local disabled=yes display-time=5s
set ether5-slave-local disabled=yes display-time=5s
set vlan3 disabled=yes display-time=5s
set vlan6 disabled=yes display-time=5s
set vlan2 disabled=yes display-time=5s
/system ntp client
set enabled=yes primary-ntp=163.117.202.33 secondary-ntp=89.248.104.162
/system routerboard settings
set cpu-frequency=720MHz protected-routerboot=disabled
/system scheduler
add interval=5m name=no-ip_ddns_update on-event=no-ip_ddns_update policy=\
    read,write,test start-date=may/13/2016 start-time=21:11:01
/system script
add name=no-ip_ddns_update owner=admin policy=read,write,test source="# No-IP \
    automatic Dynamic DNS update\r\
    \n\r\
    \n#--------------- Change Values in this section to match your setup -----\
    -------------\r\
    \n\r\
    \n# No-IP User account info\r\
    \n:local noipuser \"USUARIO_NOIP\"\r\
    \n:local noippass \"PASSWORD_NOIP\"\r\
    \n\r\
    \n# Set the hostname or label of network to be updated.\r\
    \n# Hostnames with spaces are unsupported. Replace the value in the quotat\
    ions below with your host names.\r\
    \n# To specify multiple hosts, separate them with commas.\r\
    \n:local noiphost \"HOSTNOIP\"\r\
    \n\r\
    \n# Change to the name of interface that gets the dynamic IP address\r\
    \n:local inetinterface \"pppoe-out1\"\r\
    \n\r\
    \n#-----------------------------------------------------------------------\
    -------------\r\
    \n# No more changes need\r\
    \n\r\
    \n:global previousIP\r\
    \n\r\
    \n:if ([/interface get \$inetinterface value-name=running]) do={\r\
    \n# Get the current IP on the interface\r\
    \n   :local currentIP [/ip address get [find interface=\"\$inetinterface\"\
    \_disabled=no] address]\r\
    \n\r\
    \n# Strip the net mask off the IP address\r\
    \n   :for i from=( [:len \$currentIP] - 1) to=0 do={\r\
    \n       :if ( [:pick \$currentIP \$i] = \"/\") do={ \r\
    \n           :set currentIP [:pick \$currentIP 0 \$i]\r\
    \n       } \r\
    \n   }\r\
    \n\r\
    \n   :if (\$currentIP != \$previousIP) do={\r\
    \n       :log info \"No-IP: Current IP \$currentIP is not equal to previou\
    s IP, update needed\"\r\
    \n       :set previousIP \$currentIP\r\
    \n\r\
    \n# The update URL. Note the \"\\3F\" is hex for question mark (\?). Requi\
    red since \? is a special character in commands.\r\
    \n       :local url \"http://dynupdate.no-ip.com/nic/update\\3Fmyip=\$curr\
    entIP\"\r\
    \n       :local noiphostarray\r\
    \n       :set noiphostarray [:toarray \$noiphost]\r\
    \n       :foreach host in=\$noiphostarray do={\r\
    \n           :log info \"No-IP: Sending update for \$host\"\r\
    \n           /tool fetch url=(\$url . \"&hostname=\$host\") user=\$noipuse\
    r password=\$noippass mode=http dst-path=(\"no-ip_ddns_update-\" . \$host \
    . \".txt\")\r\
    \n           :log info \"No-IP: Host \$host updated on No-IP with IP \$cur\
    rentIP\"\r\
    \n       }\r\
    \n   }  else={\r\
    \n       :log info \"No-IP: Previous IP \$previousIP is equal to current I\
    P, no update needed\"\r\
    \n   }\r\
    \n} else={\r\
    \n   :log info \"No-IP: \$inetinterface is not currently running, so there\
    fore will not update.\"\r\
    \n}"
#error exporting /tool user-manager database
#error exporting /tool user-manager profile profile-limitation
#error exporting /tool user-manager router
#error exporting /tool user-manager user
