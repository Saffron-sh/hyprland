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
	cd ./CTFs/
	rsync -avh $HOME/Documents/.projects/ctf/DSCDU_001 .
	git add .
	echo "Enter your commit:"
	read message
	git commit -m "$message"
	git push -u origin master
	cd ..
}

update_lang(){
    cd ./lang/
    echo -e "$blue Updating the lang/bash directory$norm"
    cp -rvv $HOME/.scripts/bash/ $HOME/Documents/lang/bash/
    cp -rvv $HOME/Documents/lang/ .
    git add .
    echo "Enter your commit:"
    read message
    git commit -m "$message"
    git push -u origin master
    cd ..
}

update_firelong(){
	cd ./firelong/
	rsync -avh $HOME/.scripts/python/firelong.py .
	git add .
	echo "Enter your commit: "
	read message
	git commit -m "$message"
	git push -u origin master
	cd ..
}

update_hyprland(){
	cd ./hyprland/
	rsync -avh $HOME/.config/hypr/ ./hypr/
	rsync -avh $HOME/.config/waybar/ ./waybar/
	rsync -avh $HOME/Pictures/forwall/ ./wallpapers/images/
    rsync -avh $HOME/Videos/forwall ./wallpapers/videos/
	rsync -avh $HOME/.bashrc $HOME/.bash_aliases $HOME/.bash_paths $HOME/.vimrc ./bash/
    rsync -avh $HOME/Documents/misc/git_pushes/.update_and_push.sh ./misc/
	git add .
	echo "Enter your commit: "
	read message
	git commit -m "$message"
	git push -u origin master
	cd ..
}

update_m2m(){
	cd ./m2m/
	rsync -avh $HOME/.scripts/bash/m2m.sh .
	git add .
	echo "Enter your commit: "
	read message
	git commit -m "$message"
	git push -u origin main
	cd ..
}

update_nebula(){
	cd ./nebula/
	rsync -avh $HOME/Documents/nebula/neb_things ./neb_things
	rsync -avh $HOME/Documents/nebula/neb_data ./neb_data
	git add .
	echo "Enter your commit: "
	read message
	git commit -m "$message"
	git push -u origin master
	cd ..
}

update_nethole(){
	cd ./nethole/
	rsync -avh $HOME/.scripts/bash/nethole.sh .
	git add .
	echo "Enter your commit: "
	read message
	git commit -m "$message"
	git push -u origin master
	cd ..
}

update_$to_update

