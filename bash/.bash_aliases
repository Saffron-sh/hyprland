#For quick access to places

alias sl="ls"
alias to="cd"
alias topy="cd $HOME/Documents/lang/py"
alias toc="cd $HOME/Documents/lang/"
alias toneb="cd $HOME/Documents/nebula/neb_things"
alias togit="cd $HOME/Documents/misc/git_pushes"
alias toscr="cd $HOME/.scripts"
alias topj="cd $HOME/Documents/.projects"
alias toaur="cd $HOME/Documents/misc/aur_pkgs"
alias tosilo="cd $HOME/.silo"
alias toasg="cd $HOME/Documents/assignments"
alias towork="cd $HOME/Desktop/work/redynox"

#Binaries
alias fdown="aria2c -s 16 -x 16"
alias firelong="$HOME/.scripts/python/firelong.py"
alias m2m="$HOME/.scripts/bash/m2m.sh"
alias nethole="$HOME/.scripts/bash/nethole.sh"
alias vi="vim"
alias termusic="termusic --backend mpv"

#Others
alias lspower="fastfetch | grep BAT | cut -d ' ' -f3-"
alias ping_host="ping $(ip route | grep default | cut -d ' ' -f3)"
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"
alias blueup="sudo systemctl start bluetooth;bluetoothctl scan on;bluetoothctl"
alias bluedash="bluetoothctl disconnect;sudo systemctl stop bluetooth"
