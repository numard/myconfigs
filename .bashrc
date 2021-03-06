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
HISTTIMEFORMAT="%d/%m/%y %T "

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

# OSX support for /etc/paths.d/*
if [ -x /usr/libexec/path_helper ]; then
        eval `/usr/libexec/path_helper -s`
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    rxvt-unicode) color_prompt=yes;;
    rxvt) color_prompt=yes;;
esac


PATH="/usr/local/bin:/usr/local/sbin:/usr/local/opt/curl/bin:${PATH}"

# User specific aliases and functions
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Terraform in my tools dir
PATH="$PATH:$HOME/tools/"

export PATH

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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

#if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
unset color_prompt force_color_prompt

## If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#    ;;
#*)
#    ;;
#esac

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

# Handy aliases
alias awscli='source ~/dev/venv_awscli/bin/activate; complete -C aws_completer aws'
alias json='python -mjson.tool'
alias acb='acpitool -B|head -n 2|tail -n 1'
alias acs='sync; sync; /usr/bin/xscreensaver-command -lock;  sudo acpitool -s'
alias wi='wicd-curses'
alias wicd='wicd-curses'
alias m8='sudo mtr 8.8.8.8'
alias m1='sudo mtr 10.32.140.203'
alias mq='sudo mtr www.cloud.qa1.gumtree.com.au'
alias mqa1='sudo mtr webapp001.qa1.au-qa.ams1.cloud'
alias k='kubectl'
alias i='istioctl'
alias dkc='docker compose'
alias dke='docker exec'
alias dki='docker image'
alias dkp='docker ps'
alias dkr='docker run'

#if [ `uname` == 'Darwin' ] ; then
#    alias bc3="open /Applications/Beyond\ Compare.app"
#else
#    alias bc3="bcompare"
#fi

eval "$(hub alias -s)"

alias pc="pre-commit"
alias gfa='git fetch --all'
alias gpr='git pull --rebase; git log ORIG_HEAD..'
alias gca='git commit --amend'
alias gderp='git commit -m derp'
# gcb - is a function
alias gc='git checkout'
alias gs='git status'
alias gw='git whatchanged'
alias gr='git rebase'
## gri - is a function
alias gl="/usr/bin/git log --date-order --graph --pretty=format:'%Cred%h%Creset %Cgreen(%ci)%Creset%  - %C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
# git tree
alias gt="git log --all --graph --decorate --oneline"
# git tree tags only
alias gtt="git log --graph --simplify-by-decoration --pretty=format:'%d' --all"

## alias hpr='hub pull-request -b moratorium'
alias hpr='hub pull-request --draft'
alias gback='git branch $(git rev-parse --abbrev-ref HEAD)-BACK-$(date +%Y%m%d-%H%M)'
alias cdp='cd ~/dev/puppet/'
alias cdi='cd ~/dev/infrastructure/'
alias agn="ag --nonumbers"

alias Grep="grep"

# useful for git and others
export EDITOR=vim
export VISUAL=vim
#which vimpager >/dev/null
#if [ $? == 0 ] ; then
#    export PAGER=vimpager
#    alias less=$PAGER
#    alias zless=$PAGER
#else
    export PAGER=/usr/bin/less
#fi
# original less
alias oless=/usr/bin/less


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

if [ -e ~/.git-prompt.sh ] ; then
    export GIT_PS1_SHOWDIRTYSTATE=true
    export GIT_PS1_SHOWUNTRACKEDFILES=true
    export GIT_PS1_SHOWSTASHSTATE=true
   # export GIT_PS1_SHOWCOLORHINTS=true
    source ~/.git-prompt.sh
fi

# Get name / info about ec2 instance...
ec2() {
    ec2Dir=~/Entropy/aws_info/ec2-instances/
    CWD=`pwd`
    cd $ec2Dir
    if [ "$2" == "all" ] ; then
        grep -A 7 $1 *
    else
        grep -A 7 $1 instances-latest
    fi
    
    cd $CWD
    
}

# helper to setup openstack env
function cloudme () {
    # called as 
    # cloudme ams1 au-prod
    # cloudme dus1 au-ci
    # cloudme ams1 au-ops-qa
    # cloudme dev nmeijome
    RC="${HOME}/dev/cloud/${1}/${2}-openrc.sh"
    VENV=v_nova
    
    if [ -f "${RC}" ] ; then
		source ${HOME}/dev/${VENV}/bin/activate
		source ${RC}
        export OS_REGION=${1}
        export AVI_USERNAME="${OS_USERNAME}"
        export AVI_PASSWORD="${OS_PASSWORD}"
		echo "LOADED ${OS_TENANT_NAME}"

    else
        echo "BRRRR : Cannot find tenant $2 in region $1 ( $RC )"
        echo "Syntax: cloudme {ams1|dus1|dev} {tenant_name}"
	fi

}

# Add to PS1 the openstack Tenant ID
function __get_OS_tenant () {
    if [ "${OS_TENANT_NAME}" != "" ] ; then
        echo "{${OS_TENANT_NAME}-${OS_REGION}}"
    fi
}

## OSX only :)
function get_ldappw () {
  output=$(security 2>&1 >/dev/null find-generic-password -ga ecg-ldap)
  echo $output | sed 's/password: "\(.*\)"/\1/' 2>/dev/null
}

## Get ssl cert from HTTPS endpoint
function show_cert () {

    if [ "${1}" == "" ] ; then
        echo show_cert \{SNI\} \{port:443\} \{connect_to:defaults_to_SNI\}
        return
    else
        _SNI=${1}
    fi

    if [ "${2}" == "" ] ; then
        _PORT=443
    else
        _PORT=${2}
    fi

    if [ "${3}" == "" ] ; then
        _CONNECT=${_SNI}
    else
        _CONNECT=${3}
    fi



    echo | openssl s_client -showcerts -servername ${_SNI} -connect ${_CONNECT}:${_PORT} 2>/dev/null | openssl x509 -inform pem -noout -text

}

# replacing alias so i can handle parameters. Alias for git rebase -i HEAD~<number of commits to go back>
function gri () {
    if [ "${1}" == "" ] ; then
        echo "Alias to 'git rebase -i HEAD~\$1'"
        echo gri \{number_of_commits_from_HEAD\}
        return
    fi

    git rebase -i HEAD~$1
}

function gcb () {
    git checkout -b ${1}
#     if [ $? ] ; then
#         git branch --set-upstream-to=origin/${1}
#     fi
}

export PROMPT_COMMAND='history -a'

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
#PS1="\[\033[01;34m\]\u@\h :: \D{%Y-%m-%d} \t \n[\w]\[\033[00m\]\[\e[1;\$(get_git_color)m\] \$(parse_git_branch)\[\e[0m\]\[\033[01;34m\]::\[\033[00m\] "
# my favourite for a long time...but uses up 2 lines and pretty wide
#PS1='\[\033[01;34m\]\u@\h :: \D{%Y-%m-%d} \t \n[\w]$( __git_ps1 ) :: \[\033[00m\]'

# the default, faster than my previous favourite
# with added cloud env showing
# with shorter info about username,hostname in prompt (but no changes on term title)
PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]${USER:0:2}@...\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$( __git_ps1 )$( __get_OS_tenant )\$ '

# only on bash 4+
# shortens \w to
# nmeijome@LM-SYD-00321353:~/.../modules/au (master %)
export PROMPT_DIRTRIM=2

PERL_MB_OPT="--install_base \"/Users/nmeijome/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/nmeijome/perl5"; export PERL_MM_OPT;
export CLOUD_GIT_DIR=/Users/nmeijome/git/cloud

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

## BEWARE - we are changing default OSX commands for GNU
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
eval "$(pipenv --completion)"
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'
complete -C /usr/local/bin/vault vault

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


# Keep after all other lines that modify prompt

eval "$(direnv hook bash)"
export PATH="/usr/local/opt/python@3.8/bin:$PATH"
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
PS1='$(kube_ps1)'$PS1
KUBE_PS1_NS_ENABLE=true
KUBE_PS1_PREFIX='('
KUBE_PS1_SYMBOL_ENABLE=false
KUBE_PS1_SYMBOL_DEFAULT='*'
KUBE_PS1_SYMBOL_USE_IMG=flase
KUBE_PS1_SEPARATOR='|'
KUBE_PS1_DIVIDER=':'
KUBE_PS1_SUFFIX=')'

function get_cluster_short() {
  env=$(echo $1 | cut -d _ -f2 | cut -d - -f3)
  cluster=$(echo $1 | cut -d _ -f4)
  [[ "${env}" != "" ]] && echo "${env}-${cluster}" || echo "${cluster}"
}

KUBE_PS1_CLUSTER_FUNCTION=get_cluster_short
[[ -f ~/.bashrc ]] && . ~/.bashrc
