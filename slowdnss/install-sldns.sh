#!/bin/bash
# Slowdns Instalation by Jrtunnel 19-09-2022
# ==========================================
BURIQ () {
    curl -sS https://raw.githubusercontent.com/godtrex99/permission/main/ipmini > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f /root/tmp
}

MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/godtrex99/permission/main/ipmini | grep $MYIP | awk '{print $2}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)

Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}

PERMISSION () {
    MYIP=$(curl -sS ipv4.icanhazip.com)
    IZIN=$(curl -sS https://raw.githubusercontent.com/godtrex99/permission/main/ipmini | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}
red='\e[1;31m'
green='\e[1;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
PERMISSION
if [ -f /home/needupdate ]; then
red "Your script need to update first !"
exit 0
elif [ "$res" = "Permission Accepted..." ]; then
echo -ne
else
red "Permission Denied!"
exit 0
fi
clear
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================
clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'
echo -e " [ ${green}INFO${NC} ] Installing SSH Slow DNS "
echo "Progress..." | lolcat
sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading files... "
wget -qc https://raw.githubusercontent.com/godtrex99/multimulti/main/slowdnss/hostdnss.sh && chmod +x hostdnss.sh &&  sed -i -e 's/\r$//' hostdnss.sh && ./hostdnss.sh
nameserver=$(cat /home/nsdomain)
echo -e "[ ${green}INFO${NC} ] Download File... "
echo "Progress..." | lolcat
# SSH SlowDNS
echo -e " [ ${green}INFO${NC} ] Successfully.. "
wget -qO- -O /etc/ssh/sshd_config https://raw.githubusercontent.com/godtrex99/multimulti/main/slowdnss/sshd_config
systemctl restart sshd
sleep 1
echo -e "[ ${green}INFO${NC} ] Tambahan... "
apt install screen -y
apt install cron -y
apt install iptables -y
service cron reload
service cron restart
service iptables reload
sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading files... "
cd /usr/local
wget -qc https://golang.org/dl/go1.16.2.linux-amd64.tar.gz
tar xvf go1.16.2.linux-amd64.tar.gz
export GOROOT=/usr/local/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
cd /root
apt install git -y
sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading files... "
git clone https://www.bamsoftware.com/git/dnstt.git jrtunnel
mv /root/jrtunnel /root/slowdns
rm -rf jrtunnel
cd /root/slowdns/dnstt-server
go build
echo -e "[ ${green}INFO${NC} ] Install Key... "
sleep 1
./dnstt-server -gen-key -privkey-file /root/slowdns/dnstt-server/server.key -pubkey-file /root/slowdns/dnstt-server/server.pub
echo -e "[ ${green}INFO${NC} ] Successfully... "
sleep 1
mkdir -m 777 /root/.dns
sleep 2
echo -e "[ ${green}INFO${NC} ] Waiting... "
mv /root/slowdns/dnstt-server/server.key /root/.dns/server.key
mv /root/slowdns/dnstt-server/server.pub /root/.dns/server.pub
rm -rf /etc/slowdns
mkdir -m 777 /etc/slowdns
echo -e "[ ${green}INFO${NC} ] Successfully... "
sleep 1
cd /root
rm -rf slowdns
sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading files... "
wget -qc -O /etc/slowdns/sldns-server "https://raw.githubusercontent.com/godtrex99/multimulti/main/slowdnss/sldns-server"
wget -qc -O /etc/slowdns/sldns-client "https://raw.githubusercontent.com/godtrex99/multimulti/main/slowdnss/sldns-client"
sleep 1
chmod +x /etc/slowdns/sldns-server
chmod +x /etc/slowdns/sldns-client
cd
echo -e "[ ${green}INFO${NC} ] Successfully... "
sleep 1
#wget -q -O /etc/systemd/system/client-sldns.service "https://raw.githubusercontent.com/godtrex99/multimulti/main/slowdnss/client-sldns.service"
#wget -q -O /etc/systemd/system/server-sldns.service "https://raw.githubusercontent.com/godtrex99/multimulti/main/slowdnss/server-sldns.service"
cd
sleep 1
echo -e "[ ${green}INFO${NC} ] System Prosess... "
sleep 2
install client-sldns.service
cat > /etc/systemd/system/client-sldns.service << END
[Unit]
Description=Client SlowDNS By Jrtunnel Mwoi
Documentation=https://www.jrtunnel.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/etc/slowdns/sldns-client -udp 8.8.8.8:53 --pubkey-file /root/.dns/server.pub $nameserver 127.0.0.1:3369
Restart=on-failure

[Install]
WantedBy=multi-user.target
END
cd
install server-sldns.service
cat > /etc/systemd/system/server-sldns.service << END
[Unit]
Description=Server SlowDNS By Jrtunnel Mwoi
Documentation=https://www.jrtunnel.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/etc/slowdns/sldns-server -udp :5300 -privkey-file /root/.dns/server.key $nameserver 127.0.0.1:2269
Restart=on-failure

[Install]
WantedBy=multi-user.target
END
cd
echo -e "[ ${green}INFO${NC} ] Successfully... "
chmod +x /etc/systemd/system/client-sldns.service
chmod +x /etc/systemd/system/server-sldns.service
pkill sldns-server
pkill sldns-client

iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

systemctl daemon-reload
systemctl stop client-sldns
systemctl stop server-sldns
systemctl enable client-sldns
systemctl enable server-sldns
systemctl start client-sldns
systemctl start server-sldns
systemctl restart client-sldns
systemctl restart server-sldns
cd
sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading files Success "
cd
