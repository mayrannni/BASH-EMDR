#!/bin/bash
#before running this script, first run:
#sudo apt-get install nmap
#sudo apt-get install netcat-traditional

#ask for ip or ips range
read -p "Enter the IP address or IP range to scann: " ip_range

#ask for ports range
read -p "Enter the ports range to scan (e.g., 1-1000): " port_range

#port scanning with nmap
echo "Nmap scanning ports..."
nmap -p $port_range $ip_range -oG - | grep "/open" > nmap_results.txt

#read nmap results and verify open ports
echo "Netcat checking open ports..."
while read -r line; do
        ip=$(echo $line | awk '{print $2}')
        port=$(echo $line | grep -oP '\d+/open' | cut -d '/' -f 1)
        for port in $ports; do
                nc -zv $ip $port 2>&1 | grep -q "open" && echo "Port $port on $ip is open."
        done
done < nmap_results.txt
