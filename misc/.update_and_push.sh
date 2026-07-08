#!/bin/bash

norm="\033[0;0m"
red="\033[0;31m"
blue="\033[0;34m"
to_update=$1

if [[ $# -ne 1 ]];then
	echo -e "$red Usage:$0 <repo_name>$norm"
	exit 1
fi

update_CTFs(){
	cd ./CTFs/ || exit 1
	rsync -avh --delete --exclude='.git' --exclude='.gitignore' --exclude='LICENSE' $HOME/Documents/.projects/ctf/ .
	git add .
	echo "Enter your commit:"
	read message
	git commit -m "$message"
	git push -u origin master
	cd ..
}

update_lang(){
	cd ./lang/ || exit 1
	echo -e "$blue Updating the lang/bash directory$norm"
	rsync -avh --delete --exclude='.git' --exclude='.gitignore' --exclude='LICENSE' $HOME/.scripts/bash/ $HOME/Documents/lang/bash/daily_scripts/
	rsync -avh --delete --exclude='.git' --exclude='.gitignore' --exclude='LICENSE' $HOME/Documents/lang/ .
	git add .
	echo "Enter your commit:"
	read message
	git commit -m "$message"
	git push -u origin master
	cd ..
}

update_firelong(){
	cd ./firelong/ || exit 1
	rsync -avh $HOME/.scripts/python/firelong.py .
	git add .
	echo "Enter your commit: "
	read message
	git commit -m "$message"
	git push -u origin master
	cd ..
}

update_hyprland(){
	cd ./hyprland/ || exit 1
	rsync -avh --delete --exclude='.git' --exclude='.gitignore' --exclude='LICENSE' $HOME/.config/hypr/ ./hypr/
	rsync -avh --delete --exclude='.git' --exclude='.gitignore' --exclude='LICENSE' $HOME/.config/waybar/ ./waybar/
	rsync -avh --delete --exclude='.git' --exclude='.gitignore' --exclude='LICENSE' $HOME/Pictures/forwall/ ./wallpapers/images/
	rsync -avh --delete --exclude='.git' --exclude='.gitignore' --exclude='LICENSE' $HOME/Videos/forwall/ ./wallpapers/videos/
	mkdir -p /tmp/dotfiles_stage
	cp $HOME/.bashrc $HOME/.bash_aliases $HOME/.bash_paths $HOME/.vimrc /tmp/dotfiles_stage/
	rsync -avh --delete /tmp/dotfiles_stage/ ./bash/
	rsync -avh $HOME/Documents/misc/git_pushes/.update_and_push.sh ./misc/
	rsync -avh --delete /etc/fstab ./misc/
    git add .
	echo "Enter your commit: "
	read message
	git commit -m "$message"
	git push -u origin master
	cd ..
}

update_m2m(){
	cd ./m2m/ || exit 1
	rsync -avh $HOME/.scripts/bash/m2m.sh .
	git add .
	echo "Enter your commit: "
	read message
	git commit -m "$message"
	git push -u origin main
	cd ..
}

update_nebula(){
	cd ./nebula/ || exit 1
	rsync -avh --delete --exclude='.git' --exclude='.gitignore' --exclude='LICENSE' $HOME/Documents/nebula/neb_things/ ./neb_things/
	rsync -avh --delete --exclude='.git' --exclude='.gitignore' --exclude='LICENSE' $HOME/Documents/nebula/neb_data/ ./neb_data/
	git add .
	echo "Enter your commit: "
	read message
	git commit -m "$message"
	git push -u origin master
	cd ..
}

update_nethole(){
	cd ./nethole/ || exit 1
	rsync -avh $HOME/.scripts/bash/nethole.sh .
	git add .
	echo "Enter your commit: "
	read message
	git commit -m "$message"
	git push -u origin master
	cd ..
}

update_$to_update
