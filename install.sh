#!/bin/bash

#Detection of the OS 
OS_name=`lsb_release -i | awk -F: '{ print $2 }' | awk -F ' ' '{ print $1 }'`
echo "OS name : $OS_name"

case $OS_name in 
  
  "Fedora")
    package_manager=`which dnf`
    ;;

  *)
    package_manager=0
    ;;

esac

if [ $package_manager != 0 ]
then 
  echo "Package Manager : $package_manager"
else 
  echo "Sorry ! Your OS isn't compatible yet."
  echo 1
fi 


exit 0
