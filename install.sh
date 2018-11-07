#!/bin/bash

#Detection of the OS 
OS_name=`lsb_release -i | awk -F: '{ print $2 }' | awk -F ' ' '{ print $1 }'`
echo -e "\n"
echo "OS name : $OS_name"

case $OS_name in 
  
  "Fedora")
    package_manager="`which dnf` install"
    ;;

  "Debian" | "Ubuntu" | "Raspbian")
    package_manager="`which apt-get` install"
    ;;

  *)
    package_manager=0
    ;;

esac

if [ "$package_manager" != 0 ]
then 
  echo "Package Manager : `echo $package_manager | awk -F" " '{ print $1 }'`"
else 
  echo "Sorry ! Your OS isn't compatible yet."
  exit 1
fi 


echo -e "\n"

package_list="htop powertop tlp git"

for package in $package_list
do
  echo "Installing : $package"
  echo -e "Executing : 'sudo $package_manager $package' \n"
  #sudo $package_manager $package
  echo -e "\n"
done
echo 
exit 0
