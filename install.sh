#!/bin/bash

USER2CREATE="kerboitk"

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

CURRENT_USER=`whoami`

if [ "$CURRENT_USER" -ne "root" ]
then
  echo "The current user doesn't have permission ! "
  exit 1
fi


# Creation of the user

User=`grep "$USER2CREATE" /etc/passwd`

if [ $? -eq 0 ]
then
  echo "Creating user $USER2CREATE..."
  useradd $USER2CREATE -m -s /bin/bash
  passwd $USER2CREATE
else
  echo "User $USER2CREATE already created !"
fi


if [ "$package_manager" != 0 ]
then
  echo "Package Manager : `echo $package_manager | awk -F" " '{ print $1 }'`"
else
  echo "Sorry ! Your OS isn't compatible yet."
  exit 2
fi

echo -e "\n"

package_list="htop powertop tlp git vim curl acpi "

for package in $package_list
do
  echo "Installing : $package"
  echo -e "Executing : '$package_manager $package' \n"
  exec $package_manager $package
  echo -e "\n"
done

echo "Copy configuration files"
mv /home/$USER2CREATE/.bashrc /home/$USER2CREATE/.bashrc.bak
cp ./config_files/bashrc_fedora /home/$USER2CREATE/.bashrc
cp ./config_files/gitconfig /home/$USER2CREATE/.gitconfig
cp ./config_files/tlp /etc/default/tlp

echo "Login as $USER2CREATE"
su - $USER2CREATE

echo "Installing SpaceVim and his dependancies..."
curl -sLf https://spacevim.org/install.sh | bash

echo "powertop configuration"

ac_adapter=$(acpi -a | cut -d' ' -f3 | cut -d- -f1)

if [ "$ac_adapter" = "off" ]
then
  echo -e "This PC has to be on AC, please try-again...\n"
  exit 3
fi

sudo powertop --calibrate
sudo powertop --auto-tune

echo "Generate SSH key"
pushd ~/.ssh/ > /dev/null
ssh-keygen -t rsa -b 4096
popd > /dev/null

exit 0

