#!/bin/bash

#Detection of the OS 
OS_name=`lsb_release -i | awk -F: '{ print $2 }' | awk -F ' ' '{ print $1 }'`
echo $OS_name

exit 0
