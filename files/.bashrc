#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# better yaourt colors
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"
#
# Define default prompt to <username>@<hostname>:<path><"($|#) ">
# and print '#' for user "root" and '$' for normal users.
#

#!typeset +x PS1="\u@\h:\w\\$ "
#if [[ $EUID -ne 0 ]]; then
#    PS1="\e[97m[\e[1m\e[0;33;40m\A \e[97m|\e[0;33;40m \u\e[97m\e[21m] \w \e[32m\$ \e[0m"
#export PS1="\[\e[0;33m\][\[\e[1;33m\]\u@\h\[\e[0;31m\]] \[\e[1;33m\]\W \\$\[\e[1;32m\] "
#else
#    PS1="\e[93m[\e[1m\e[0;31;40m\A \e[93m|\e[0;31;40m \u\e[93m\e[21m] \w \e[31m# \e[0m"
#export PS1="\[\e[0;31m\][\[\e[1;33m\]\u@\h\[\e[0;31m\]] \[\e[1;33m\]\W \\$\[\e[1;32m\] "
#fi

export PS1="\[\e[0;31m\][\[\e[1;33m\]\u@\h\[\e[0;31m\]] \[\e[1;33m\]\W \\$\[\e[00m\] "
export PS2="\e[1;33m>\e[00m] "
alias cu='sudo su'
alias lsltr='ls -ltr'
alias lsltra='ls -ltra'
alias lsl='ls -l'
alias ll='ls -l'
alias lsla='ls -la'
alias hist='history | grep'
alias mdf='df -h'
alias mfree='free -m'
alias psgrep='ps -ef | grep -v grep | grep'
#alias vi='vim'

function bck { suf=`date +_%Y%m%d_%H%M`; cp $1 $1$suf;echo "File $1 backuped to $1$suf"; }

function lsgrep { if [ "$2" != "" ]; then ls -ln $1 | grep $2; else ls -ln | grep $1; fi; }

function showpath { 
IFS="/";read -r -a array <<< "$1";IFS=" "
oldE="/"
allEs=""
for E in "${array[@]}" 
do 
if [ "$E" != "" ]
then
allEs="$allEs $oldE$E"
oldE="$oldE$E/"
fi
done 
ls -ld $allEs 2>/dev/null 
}


HISTCONTROL=erasedups
clear

echo -e "\e[1;33m/###################################################################################"
echo "|   Welcome $USER !"
echo "|"
echo "|   YOU:  $(id)"
echo "|   PWD:  $(pwd)"
echo "|   SYS:  $(uname -a)"
echo "|   UPT:  $(uptime)"
echo "|"
echo -e "|##################################################################################/\e[00;00m"
echo
echo

export VISUAL=nano
HISTTIMEFORMAT='%F %T '

alias kubectl="microk8s.kubectl"
