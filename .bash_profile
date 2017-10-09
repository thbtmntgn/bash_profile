#!/bin/bash
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
alias mysql='mysql --user=root --password'

# Change Prompt [[ Working directory @ hostname (user) [time at date] ]]
#-------------------------------------------------------------------------------
export PS1="________________________________________________________________________________\n| \w @ \h (\u) [$( nowtime ) at $( nowdate )] \n| => "

# Set Paths
#-------------------------------------------------------------------------------
export PATH="${PATH}:"


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

# Personnal
#-------------------------------------------------------------------------------
source ~/.bash_perso       # Personnal bash profile
