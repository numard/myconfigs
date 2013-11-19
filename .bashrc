# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi


# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    rxvt-unicode) color_prompt=yes;;
    rxvt) color_prompt=yes;;
esac

PATH=$PATH:/home/beto/dev/go/bin:/sbin/

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Handy aliases
alias awsmain="source ~/bin/aws_main.sh"
alias awstest="source ~/bin/aws_systest.sh"
alias pssh=parallel-ssh
alias g="/usr/bin/gitg &"
alias mh='time ( cd ~/dev/engwiki/docs ; make html)'
alias mc='( cd ~/dev/engwiki/docs ; time make clean ; mh )' 
alias envaws='source ~/dev/env.aws/bin/activate'
alias json='python -mjson.tool'
alias acb='acpitool -B|head -n 2|tail -n 1'
alias acs='sync; sync; /usr/bin/xscreensaver-command -lock;  sudo acpitool -s'
alias wi='wicd-curses'
alias wicd='wicd-curses'
alias vpn='(cd _1/vpn ; sudo openvpn --config clientEC2.conf --script-security 2)'
alias vpnsyd='(cd _1/vpn ; sudo openvpn --config clientSYD.conf --script-security 2)'
alias loadkeys='ssh-add ~/.ssh/id_rsa ; ssh-add ~/_1/access_aws/main/f8r-20120810 ; ssh-add ~/_1/access_aws/main/freelancer-sg.pem ; ssh-add ~/_1/access_aws/main/freelancer-us-oregon.pem ; ssh-add ~/_1/access_aws/main/pshan-20130521.pem; ssh-add ~/_1/access_aws/whitehats_sectest/whitehats_aws-20130225.pem ; echo ; ssh-add -l'
alias loaddisks='truecrypt -t --auto-mount=favorites'
alias arct='arc todo'
alias vmm='vm-manage'

# useful for git and others
export EDITOR=vim
export VISUAL=vim

## Hook up to EC2 tools
export PATH=$PATH:~beto/bin/ec2-api-tools/bin/
export EC2_HOME=~beto/bin/ec2-api-tools/

## Hook up to IAM AWS tools
export PATH=$PATH:~beto/bin/iam-cli-tools/bin/
export AWS_IAM_HOME=~beto/bin/iam-cli-tools/

## Hook up to RDS AWS tools
export PATH=$PATH:~beto/bin/rds-cli-tools/bin/
export AWS_RDS_HOME=~beto/bin/rds-cli-tools/

## Hook up to AWS ELB tools

export PATH=$PATH:~beto/bin/elb-tools/bin/
export AWS_ELB_HOME=~beto/bin/elb-tools/

# JAVA - needed for AWS CLI
export JAVA_HOME=/opt/jdk/jre
export PATH=$PATH:/opt/jdk/bin:$JAVA_HOME

## Support for arcanist
export PATH=$PATH:~beto/bin/arcanist/bin
# Autocomplete support for arcanist
source ~/bin/arcanist/resources/shell/bash-completion

# Avoid having to write freelancer.com for every host
export LOCALDOMAIN=freelancer.com

# Perl specifics - added by Mr Cpan
export PERL_LOCAL_LIB_ROOT="/home/beto/perl5";
export PERL_MB_OPT="--install_base /home/beto/perl5";
export PERL_MM_OPT="INSTALL_BASE=/home/beto/perl5";
export PERL5LIB="/home/beto/perl5/lib/perl5/x86_64-linux-gnu-thread-multi:/home/beto/perl5/lib/perl5";
export PATH="/home/beto/perl5/bin:$PATH";
export PATH=$PATH:/opt/vagrant/bin:/opt/node/bin

# An alternative to making an alias...which doesn't support the use of parameters, so i can't add $1 before a &..which means the first use of e ties my screen to the process 
e() {
    nohup scite $1 & 2>&1 >/dev/null
}


function parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
    
}

function get_git_color() {

    isred=`git status -s 2> /dev/null | egrep "^.[^? ]" | wc | awk '{print $1}'`
    isorange=`git status -s 2> /dev/null | egrep "^[^? ]" | wc | awk '{print $1}'`

    git_prompt_color=32

    if [ $isorange -ne 0 ]
    then
    git_prompt_color=33
    fi
    if [ $isred -ne 0 ]
    then
    git_prompt_color=31
    fi
    
    echo "$git_prompt_color"
}


# Get name / info about ec2 instance...
ec2() {
    ec2Dir=~/Dropbox/work/Freelancer/aws_info/ec2-instances/
    CWD=`pwd`
    cd $ec2Dir
    if [ "$2" == "all" ] ; then
        grep -A 7 $1 *
    else
        grep -A 7 $1 instances-latest
    fi
    
    cd $CWD
    
}

clearapc() {
	ssh ${1}.freelancer.com "curl http://localhost:8080/clear.php"
}

copykeys() {
	ssh-copy-id -i ~/dev/pubkeys/keydir/${1}.pub ${2} 
}

jump() {
    ssh -t syd1.freelancer.com ssh $1
}

# Guide to prompt:
#  * set the title bar to show the current time (\t) & current working directory (\w): "\[\e]0;\t \w\a\]"
#  * set the prompt to show:
#      * current user (\u) and host (\h) in green (\[\e[32m\]), 
#      * working directory (\w) in yellow (\[\[e[33m\]): "\[\e[32m\]\u@\h \[\e[33m\]\w 
#  * add the git branch name to the prompt: $(parse_git_branch)
#  * set color for git branch name based on status:
#     * all previously tracked files up-to-date/committed: green
#     * any previously tracked files NOT added: red
#     * some previously tracked files added but not committed: orange
#export PS1="\[\e]0;\t \w\a\]\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[1;\$(get_git_color)m\] \$(parse_git_branch)\[\e[0m\]> "

#PS1="\[\033[01;34m\]\D{%Y-%m-%d} \t :: ${debian_chroot:+($debian_chroot)}\u@\h\n[\w] \$ :\[\033[00m\]"
#PS1="\[\033[01;34m\]${debian_chroot:+($debian_chroot)}\u@\h :: \D{%Y-%m-%d} \t \n[\w] \$:\[\033[00m\]"
PS1="\[\033[01;34m\]\u@\h :: \D{%Y-%m-%d} \t \n[\w]\[\033[00m\]\[\e[1;\$(get_git_color)m\] \$(parse_git_branch)\[\e[0m\]\[\033[01;34m\]::\[\033[00m\]"

