#!/bin/bash

#Global Variables:

#Colours
norm="\033[0m"
red="\033[0;31m"
green="\033[0;32m"
blue="\033[0;34m"

#Others
VERSION=1.0.0
WORKING_DRIVE=""
HOSTNAME=""
USERNAME=""

banner(){
	clear
	echo -e "+-----------------------------------+"
	echo -e	"+      Saffron Mothership Setup     +"
	echo -e	"+         Version : "$VERSION"           +"
	echo -e	"+-----------------------------------+"
	
	printf "Available Drives: $green"
	for i in $(lsblk -ldno NAME);do
		printf "$i "
	done
	printf "$norm\n"
	
}

print_red(){
	echo -e "\n$red[${norm}BAD${red}] $1 $norm\n"
}
print_green(){	
	echo -e "\n$green[${norm}OK${green}] $1 $norm\n"
}
print_blue(){
	echo -e "\n$blue[${norm}*${blue}] $1 $norm\n"
}

generic_error(){
	print_red "An error occured"
	exit 1
}

checkroot(){
	if [[ "$EUID" -ne 0 ]];then
		print_red "Setup must be run as root"
		exit 1
	fi
}

find_drives(){
	lsblk -o NAME,FSTYPE,FSUSED,FSSIZE,FSUSE%,UUID
}

check_drive_present(){
	local tocheck="$1"
	
	if ! lsblk -do NAME | grep -qx "$tocheck";then
		print_red "Drive not present. Exiting"
		exit 1
	else
		print_green "Drive Present. Updated Working drive to /dev/$tocheck"
	fi
}

askfor_confirmation(){
	local initial_choice=""
	local final_choice=""

	print_blue "Proceed with modification of the selected drive?"
	read -rp "[y/n]: " initial_choice

	if [[ "$initial_choice" == "y" ]];then
		
		print_red "This operation will DESTROY ALL DATA on the selected drive. Proceed?"
		read -rp "[y/n]: " final_choice
		
		if [[ "$final_choice" == "y" ]];then
			print_green "Modification order confirmed. Proceeding..."
		else
			print_blue "Modification order cancelled. Exiting"
			exit 0
		fi

	else
		print_blue "Modification order cancelled. Exiting"
		exit 0

	fi
}

modify_drive(){
	local local_working_drive="/dev/$1"
	
	#Wiping the chosen drive's existing signature

	print_blue "==========Before State [WIPE]=========="
	find_drives

	print_blue "Wiping existing signatures from the drive"
	sleep 2
	if wipefs -a "$local_working_drive";then
		print_green "Signatures wiped"
	else
		generic_error
	fi	

	print_blue "==========After State [WIPE]=========="
	find_drives
	
	sleep 2

	#Creating partitions in the now empty drive

	print_blue "Modifying Drive"
	
	sfdisk "$local_working_drive" <<EOF
	label: gpt
	size=512M,type=U,name=EFI
	type=L,name="Linux root"
EOF
	
	if [[ $? -eq 0 ]];then
		print_green "Modification Complete"
	else
		generic_error
	fi

	print_blue "==========After State [MOD]=========="
	find_drives
	sleep 2

	#Formatting the created partitions

	print_blue "Formatting the partitons"
	
	local drive_type=$(lsblk -ldno TRAN "$local_working_drive")

	if [[ "$drive_type" == "sata" ]] || [[ "$drive_type" == "usb" ]];then
		partition_one="$local_working_drive"1
		partition_two="$local_working_drive"2
	else 
		partition_one="$local_working_drive"p1
		partition_two="$local_working_drive"p2
	fi

	if mkfs.fat -F32 "$partition_one" && mkfs.ext4 "$partition_two";then
		print_green "Formatting complete"
	else
		generic_error
	fi

	print_blue "==========After State [FORMAT]=========="
	find_drives
	sleep 2

	#Moutning the formatted partitions

	if mount "$partition_two" /mnt && mount --mkdir "$partition_one" /mnt/boot;then
		print_green "Drive mounted and ready."
	else
		generic_error
	fi

}

install_base(){
	print_blue "Installing the arch linux kernel [Pacstrap]"
	
	if pacstrap -K /mnt base linux linux-firmware sudo;then
		print_green "Kernel Installed successfully"
	else
		generic_error
	fi
}

generate_fstab(){
	print_blue "Generating file system table"

	if genfstab -U /mnt >> /mnt/etc/fstab;then
		print_green "Table generated"
		echo "==========FSTAB=========="
		cat /etc/fstab
		echo "==========FSTAB=========="

	else
		generic_error
	fi
}

chroot(){
	print_blue "Entering installed system"

	arch_chroot /mnt
}

establish_identity(){

	local hostname
	local username

	#Preparations for doing the stuff

	print_blue "Enter Desired Name for the machine (This will appear in the terminal)"
	read -rp ">> " hostname

	print_blue "Enter Desired username (this user will have root privileges)"
	read -rp ">> " username

	alias set_time_zone="ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime && hwclock --systohc"
	
	alias set_locale="sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen && \ 
		          locale-gen && \ 
			  echo 'LANG=en_US.UTF-8' > /etc/locale.conf"
	
	alias set_host="echo -r '$hostname' > /etc/hostname"

	alias populate_hosts_local_dns="echo -e '127.0.0.1 localhost\n::1 localhost\n127.0.1.1 $hostname.localdomain $hostname > /etc/hosts'"

	#Actually doint the stuff
	
	print_blue "Setting Time Zone"

	if set_time_zone;then
		print_green "Time Zone set successfully"
	else
		generic_error
	fi

	print_blue "Generating and setting the locale"

	if set_locale;then
		print_green "Locale successfully configured"
	else
		generic error
	fi

	print_blue "Setting hostname and localhost dns"
	
	if set_host && populate_hosts_local_dns;then
		print_green "Hostname and dns configured"
	else
		generic error
	fi

}

main(){
	banner
	
	checkroot

	print_blue "Choose one to continue setup"

	find_drives

	print_blue "Enter only the drive name [sda/sdb/nvme0n1/nvme0n2] not inner partitions"

	read -rp ">> " WORKING_DRIVE
	
	check_drive_present "$WORKING_DRIVE"

	askfor_confirmation

	modify_drive "$WORKING_DRIVE"
} 

main
