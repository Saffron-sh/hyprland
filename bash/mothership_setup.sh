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

get_user_attention(){
	for i in 0 1 2 3 4;do
		printf "seeeee\n"
		sleep 0.4
	done
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
		cat /mnt/etc/fstab
		echo "==========FSTAB=========="

	else
		generic_error
	fi
}

chroot(){
	print_blue "Entering installed system"

	arch_chroot /mnt
}

set_time_zone(){
	ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime && hwclock --systohc

}
set_locale(){
	sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen 
	locale-gen
	echo 'LANG=en_US.UTF-8' > /etc/locale.conf
}

set_host(){
	local hostname
	
	get_user_attention
	print_blue "Enter Desired Name for the machine (This will appear in the terminal)"
	read -rp ">> " hostname
	
	printf "%s\n" ${hostname} > /etc/hostname

cat > /etc/hosts <<EOF
127.0.0.1	localhost
::1		localhost
127.0.1.1	${hostname}.localdomain		${hostname}
EOF
}

set_root_passwd(){
	get_user_attention
	print_blue "Enter root passwd"
	passwd
}

create_second_user(){
	local username
	
	get_user_attention
	print_blue "Enter the username of the second user (this user will have root privileges if you modify VISUDO)"
	read -rp ">> " username

	useradd -m -G wheel "$username"

	print_blue "Enter password for $username"
	passwd ${username}
}

install_cpu_gpu_packages(){
	cpu_vendor=$(cat /proc/cpuinfo | grep -Ei 'GenuineIntel|AuthenticAMD')
	gpu_vendor=$(lspci | grep -Ei 'VGA compatible controller|3D controller|Display controller' | head -n1)

	print_blue "Installing CPU and GPU sepcific packages"

	case "$cpu_vendor" in
		*GenuineIntel*)
			print_blue "Intel CPU detected"
			
			if pacman -S intel-ucode;then
				print_green "CPU Packages downloaded"
			else
				generic_error
			fi

			;;

		*AuthenticAMD*)
			print_blue "AMD CPU detected"
			
			if pacman -S amd-ucode;then
				print_green "CPU Packages downloaded"
			else
				generic_error
			fi
			;;

		*)
			print_red "Unknown CPU model. TF are u installing arch on?"
			exit 1
			;;
	esac

	case "$gpu_vendor" in
		*Intel*)
			print_blue "Intel graphics detected"
			
			if pacman -S mesa vulkan-intel;then
				print_green "GPU packages downloaded"
			else
				generic_error
			fi

			;;

		*AMD*)
			print_blue "AMD graphics detected"
			
			if pacman -S mesa vulkan-radeon;then
				print_green "GPU packages downloaded"
			else
				generic_error
			fi

			;;

		*Nvidia*)
			print_blue "Nvidia graphics detected"
			
			if pacman -S nvidia nvidia-utils;then
				print_green "GPU packages downloaded"
			else
				generic_error
			fi

			;;
		*)
			print_red "What exactly are you trying to install arch on?"
			exit 1
			;;
	esac


}

setup_network(){
	print_blue "Installing networkmanager"

	if pacman -S networkmanager iwd;then
		print_green "Installed"
	else
		generic_error
	fi

cat > /etc/NetworkManager/conf.d/wifi_backend.conf <<EOF
[device]
wifi.backend=iwd
EOF
}

setup_bootloader(){
	print_blue "Installing GRUB"

	if pacman -S grub efibootmgr;then
		print_green "Installed"
	else
		generic_error
	fi

	print_blue "Configuring"

	if grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB && grub-mkconfig -o /boot/grub/grub.cfg;then
		print_green "Configured Successfully"
	else
		generic_error
	fi
}

complete_phase_one(){
	print_blue "Exiting chroot"
	exit
	print_blue "Unmounting partitions"
	umount -R /mnt
	print_blue "Rebooting now"
	get_user_attention
	print_red "REBOOT MANUALLY DUMBASSS"
}

establish_identity(){
		
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
		generic_error
	fi

	print_blue "Setting hostname and localhost dns"
	
	if set_host;then
		print_green "Hostname and dns configured"
	else
		generic_error
	fi

	print_blue "Setting Root password"

	if set_root_passwd;then
		print_green "root password set"
	else
		generic_error
	fi

	print_blue "Adding Alternate User"

	if create_second_user;then
		print_green "Added"
	else
		generic_error
	fi

}

setup_phase_one(){
	install_cpu_gpu_packages
	
	setup_network
	
	setup_bootloader

	complete_phase_one	
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

	install_base

	generate_fstab

	chroot

	establish_identity

	setup_phase_one

	complete_phase_one
} 

