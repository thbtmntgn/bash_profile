#!/bin/bash

#-------------------------------------------------------------------------------
# Alias
#-------------------------------------------------------------------------------

alias cp='cp -ivn'                                              # Preferred 'cp' implementation
alias mv='mv -iv'                                               # Preferred 'mv' implementation
alias rm='rm -i'                                                # Preferred 'rm' implementation
alias mkdir='mkdir -pv'                                         # Preferred 'mkdir' implementation
alias ls='ls -lhpFG'                                            # Preferred 'ls' implementation
alias ll='ls -alhpFG'                                           # Preferred 'ls -a' implementation
alias  l='ls -lhpFG'                                            # Same as ll alias
alias less='less -FSRXc'                                        # Preferred 'less' implementation
alias cd..='cd ../'                                             # Go back 1 directory level (for fast typers)
alias ..='cd ../'                                               # Go back 1 directory level
alias c='clear'                                                 # c : clear terminal display
alias reload='source ~/.bash_profile'                           # source .bash_profile (.bashrc, .profile, ...)
alias which='type -all'                                         # which : find executables
alias path='echo -e ${PATH//:/\\n}'                             # path : echo all executable Paths
alias nowtime='date +"%T"'                                      # get time in HH:MM:SS format
alias nowdate='date +"%d-%m-%Y"'                                # get date in DD-MM-AAAA format
alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete" # cleanupDS:  Recursively delete .DS_Store files
alias desktop='cd ${HOME}/Desktop/'                             # desktop: go to Desktop directory
alias document='cd ${HOME}/Documents/'                          # document: go to Documents directory
alias downloads='cd ${HOME}/Downloads/'                         # downloads: go to Downloads directory

#-------------------------------------------------------------------------------
# Change Prompt [[ Working directory @ hostname (user) [time at date] ]]
#-------------------------------------------------------------------------------
export PS1="________________________________________________________________________________\n| \w @ \h (\u) [$( nowtime ) at $( nowdate )] \n| => "

#-------------------------------------------------------------------------------
# Fonctions
#-------------------------------------------------------------------------------

cdl() { builtin cd "$@"; l; }           # Always list directory contents upon 'cd'
mcd () { mkdir "${1}" && cd "${1}"; }   # Makes new Dir and jumps inside
trash () { command mv "$@" ~/.Trash ; } # Moves a file to the MacOS trash

#   mans:   Search manpage given in argument '1' for term given in argument '2' (case insensitive)
#           displays paginated result with colored search terms and two lines surrounding each hit.
#           Example: mans mplayer codec
mansearch () {
	man ${1} | grep -iC2 $2 | less
}

#   pman:   Display man page in a pdf file
man2pdf () {
	man -t $* | ps2pdf - - | open -g -f -a /Applications/Preview.app
}

#   extract:  Extract most known archives with one command
extract () {
	if [ -f ${1} ] ; then
		case ${1} in
			*.tar.xz)  tar -xJf ${1}    ;;
			*.tar.bz2) tar xjf ${1}     ;;
			*.tar.gz)  tar xzf ${1}     ;;
			*.bz2)     bunzip2 ${1}     ;;
			*.rar)     unrar e ${1}     ;;
			*.gz)      gunzip ${1}      ;;
			*.tar)     tar xf ${1}      ;;
			*.tbz2)    tar xjf ${1}     ;;
			*.tgz)     tar xzf ${1}     ;;
			*.zip)     unzip ${1}       ;;
			*.Z)       uncompress ${1}  ;;
			*.7z)      7z x ${1}        ;;
			*)         echo "'${1}' cannot be extracted via extract()" ;;
		esac
	else
		echo "'${1}' is not a valid file"
	fi
}

# Delete aux. latex files
cleanlatex () {
	if [ -z "${1}" ]; then
		echo "File name is missing"
	else
		if [ -e "${1}.aux" ]     ; then command rm ${1}.aux     ; fi
		if [ -e "${1}.bcf" ]     ; then command rm ${1}.bcf     ; fi
		if [ -e "${1}.log" ]     ; then command rm ${1}.log     ; fi
		if [ -e "${1}.out" ]     ; then command rm ${1}.out     ; fi
		if [ -e "${1}.nav" ]     ; then command rm ${1}.nav     ; fi
		if [ -e "${1}.snm" ]     ; then command rm ${1}.snm     ; fi
		if [ -e "${1}.toc" ]     ; then command rm ${1}.toc     ; fi
		if [ -e "${1}-blx.bib" ] ; then command rm ${1}-blx.bib ; fi
		if [ -e "${1}.run.xml" ] ; then command rm ${1}.run.xml ; fi
	fi
}

# xelatex
xelatex_compilation () {
	if [ -z "${1}" ]; then
		echo "File name is missing"
	else
		BASENAME=$( basename ${1} )
		NAME=${BASENAME%%.*}
		xelatex ${NAME}.tex
		xelatex ${NAME}.tex
		open ${NAME}.pdf
	fi
}

timezone (){
	SANDIEGO=$( TZ=/usr/share/zoneinfo/US/Pacific date -R )
	LYON=$( TZ=/usr/share/zoneinfo/CET date -R )
	echo ""
	echo -e "San Diego : ${SANDIEGO}"
	echo -e "Lyon      : ${LYON}"
	echo ""
}

# Markdown to pdf using pandoc
md2pdf() {
	# CMD="pandoc ${1} -N -V geometry:\"top=2cm, bottom=2cm, left=2cm, right=2cm\" --output=${1}.pdf"
	CMD="pandoc ${1} --template sungenomics.latex -N -V geometry:\"top=2cm, bottom=2cm, left=2cm, right=2cm\" --listings --output=${1}.pdf"
	echo -ne "> Command: ${CMD}\n"
	eval ${CMD}
	open ${1}.pdf
}

# Remove launch agents
remove_launch_agents () {

	for AGENT in $( command ls ~/Library/LaunchAgents/* /Library/LaunchAgents/* /Library/LaunchDaemons/* ) ; do
	echo ${AGENT}
	command rm ${AGENT}
	done

}

# Update homebrew
update_homebrew () {

	echo
	echo "Update Homebrew"
	echo "--> brew update"
	brew update
	echo "--> brew upgrade"
	brew upgrade
	echo "--> brew cask upgrade --greedy"
	brew cask upgrade --greedy
	echo "--> brew cleanup"
	brew cleanup
	echo "--> brew cask doctor"
	brew cask doctor
	echo "--> brew doctor"
	brew doctor
	echo

}

update_gem () {

	echo
	echo "Update Gem (Ruby)"
	echo "--> gem update --system"
	sudo gem update --system
	echo "--> gem update"
	sudo gem update
	echo "--> gem cleanup"
	sudo gem cleanup
	echo

}

# Update pip
update_pip () {

	echo
	echo "Update pip (python)"
	pip list --format=freeze | awk '{print $1;}' | xargs -n1 pip install -U
	echo

}

update_all (){
	
	update_homebrew
	update_gem
	update_pip

}

music_search (){

	WORDS="${@}"

	find ${MUSIC_FOLDERS} -type f -name '*.mp3' -or -name '*.flac' > "/tmp/music_search.log1"

	for WORD in ${WORDS} ; do 

		grep -w -i ${WORD} "/tmp/music_search.log1" > "/tmp/music_search.log2"

		command mv "/tmp/music_search.log2" "/tmp/music_search.log1"
	
	done

	cat "/tmp/music_search.log1" 

	command rm -f "/tmp/music_search.log1"

}

music_play (){

	tr '\n' '\0' | xargs -0 -L1 open

}

#-------------------------------------------------------------------------------
# Personnal
#-------------------------------------------------------------------------------

source ~/.bash_perso # Personnal bash profile
