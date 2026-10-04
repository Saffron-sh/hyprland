FPEN="Parker_vector_metallic"
Total_Outstading="160610/- as of June 29, 2026"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

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
colours(){
	echo 'white="\033[0m"'
	echo 'red="\033[0;31m"'
	echo 'green="\033[0;32m"'
	echo 'yellow="\033[0;33m"'
	echo 'blue="\033[0;34m"'
	echo 'pink="\033[0;35m"'
	echo 'cyan="\033[0;36m"'
}

