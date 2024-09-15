#!/bin/bash
#before running this script, first run:
#sudo apt-get install htop
#sudo apt-get install top
#sudo apt-get install vmstat
#sudo apt-get install iostat
#sudo apt-get install procps
#sudo apt-get install sysstat

#warning thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

#function to check cpu usage
check_cpu() {
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100-$1}')
    echo "CPU usage: $cpu_usage%"
    if (($(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
       echo "WARNING: CPU usage over $CPU_THRESHOLD%!"
    fi
}

#function to check memory usage
check_memory() {
    memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    echo "Memory usage: $memory_usage%"
    if (($(echo "$memory_usage > $MEMORY_THRESHOLD" | bc -l) )); then
       echo "WARNING: Memory usage over $MEMORY_THRESHOLD%!"
    fi
}
 
#function to check disk usage
check_disk() { 
    disk_usage=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
    echo "Disk usage: $disk_usage%"
    if [ $disk_usage -gt $DISK_THRESHOLD ]; then
       echo "WARNING: Disk usage over $DISK_THRESHOLD%!"
    fi
}

#system performance with vmstat
check_vmstat() {
    echo "vmstat: System performance"
    vmstat 1 5
}

#disk performance with iostat
check_iostat() {
   echo "iostat: Disk performance"
   iostat -dx 1 5
}

#call functions
check_cpu
check_memory
check_disk
check_vmstat
check_iostat
