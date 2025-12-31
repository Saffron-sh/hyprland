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
alias djdown='yt-dlp -x \
  --audio-format flac \
  --audio-quality 0 \
  --embed-metadata \
  --embed-thumbnail \
  --no-write-thumbnail \
  --parse-metadata "title:%(title)s" \
  --parse-metadata "artist:%(channel)s" \
  -o "%(title)s.%(ext)s" '
alias termusic="termusic --backend mpv"
alias pahed="~/Desktop/git_clones/animepahe-cli/build/animepahe-cli-beta"

#Others
alias lspwr="fastfetch | grep BAT | cut -d ' ' -f3-"
alias ping_host="ping $(ip route | grep default | cut -d ' ' -f3)"
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"
alias blueup="sudo systemctl start bluetooth;bluetoothctl scan on;bluetoothctl"
alias bluedash="bluetoothctl disconnect;sudo systemctl stop bluetooth"
alias wiup="iwctl station wlan0 scan;sleep 1;iwctl station wlan0 connect myPoco;sleep 1;iw dev"
alias widash="iwctl station wlan0 disconnect;iw dev"
