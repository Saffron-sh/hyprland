export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '


export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

#Bash aliases in one file

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

#Bash paths in one file

if  [[ -f ~/.bash_paths ]]; then
	. ~/.bash_paths
fi


#Personal Scripts:

#functions:
sgc(){
	for csource in "$@";do
		executable="${csource%.*}"
		gcc "$csource" -o "$executable"
	done
}

sgp(){
	for psource in "$@";do
		executable="${psource%.*}"
		g++ "$psource" -o "$executable"
	done	
}

#Alerting me if Catbox if offile
[[ -f $HOME/.scripts/bash/offline_alert.sh ]] && $HOME/.scripts/bash/offline_alert.sh
#The TO-DO list:
[[ -f $HOME/.scripts/bash/to_do_list.sh ]] && $HOME/.scripts/bash/to_do_list.sh
