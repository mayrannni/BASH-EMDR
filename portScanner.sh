#!/bin/bash
#found on pentestlab.wordpress.com

#parameters
host=$1
firstport=$2
lastport=$3

#function to scan
function portscan {
    for (( counter=$firstport; counter<=$lastport; counter++ ))
    do
        (echo >/dev/tcp/$host/$counter)>/dev/null 2>&1 && echo "$counter open"
    done
}

#call function
portscan
