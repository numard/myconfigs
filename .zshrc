export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=vim
## BEWARE - we are changing default OSX commands for GNU
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/python@3.8/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
# Terraform in my tools dir
export PATH="$PATH:$HOME/tools/:$HOME/bin"

export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

	autoload -Uz compinit
	compinit
fi

eval "$(pipenv --completion)"

## Prompt setup
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
if [ -e ~/.git-prompt.sh ] ; then
    export GIT_PS1_SHOWDIRTYSTATE=true
    export GIT_PS1_SHOWUNTRACKEDFILES=true
    export GIT_PS1_SHOWSTASHSTATE=true
#    export GIT_PS1_SHOWCOLORHINTS=true
    source ~/.git-prompt.sh
fi

# the default, faster than my previous favourite
# with added cloud env showing
# with shorter info about username,hostname in prompt (but no changes on term title)
#
# long but working zsh
# (⎈ |gke_gumtree-au-prod_australia-southeast1_apps-syd-02:prod-mysql)nmeijome@LM-SYD-15001919 ~ % echo $PS1
# $(kube_ps1)%n@%m %1~ %#

PS1='$( __git_ps1 )$( __get_OS_tenant ) $( __short_username_machine ) %3~ %# '


# Keep after all other lines that modify prompt
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


# Autocomplete
zstyle :compinstall filename '/Users/nmeijome/.zshrc'
eval "$(direnv hook zsh)"
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
complete -o nospace -C /usr/local/bin/vault vault

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# History config
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=6000
setopt EXTENDED_HISTORY
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST 
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
# verify commands from history rather than exec right away
setopt HIST_VERIFY

# force emacs bindkeys for the line editor (somewhat more standard than vim mode...)
bindkey -e
unsetopt beep
setopt NO_CASE_GLOB
# revert to bash autocomplete behaviour
# setopt GLOB_COMPLETE
setopt AUTO_CD

# BEWARE, this alias to python fucks up venvs - add this line back in <venv>/bin/activate to its deactivate function
# and unalias python to its activate/main func
alias python='python3'
alias json='python -mjson.tool'
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
alias cdp='cd ~/gt_dev/puppet/'
alias cdi='cd ~/gt_dev/infrastructure/'
alias agn="ag --nonumbers"

alias Grep="grep"

# helper to setup openstack env
function cloudme () {
    # called as
    # cloudme ams1 au-prod
    # cloudme dus1 au-ci
    # cloudme ams1 au-ops-qa
    # cloudme dev nmeijome
    RC="${HOME}/gt_dev/cloud/${1}/${2}-openrc.sh"
    VENV=v_nova

    if [ -f "${RC}" ] ; then
                source ${HOME}/gt_dev/${VENV}/bin/activate
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

function __short_username_machine () {
    H=$(uname -n)
    echo $USER[1,2]@$H[1,4]..$H[-4,-1]
}

## OSX only :)
function get_ldappw () {
  output=$(security 2>&1 >/dev/null find-generic-password -ga ecg-ldap)
  echo $output | sed 's/password: "\(.*\)"/\1/' 2>/dev/null
}

## Get ssl cert from HTTPS endpoint
function show_cert () {

    if [ "${1}" -eq  "" ] ; then
        echo show_cert \{SNI\} \{port:443\} \{connect_to:defaults_to_SNI\}
        return
    else
        _SNI=${1}
    fi

    if [ "${2}" -eq "" ] ; then
        _PORT=443
    else
        _PORT=${2}
    fi

    if [ "${3}" -eq "" ] ; then
        _CONNECT=${_SNI}
    else
        _CONNECT=${3}
    fi



    echo | openssl s_client -showcerts -servername ${_SNI} -connect ${_CONNECT}:${_PORT} 2>/dev/null | openssl x509 -inform pem -noout -text

}

# replacing alias so i can handle parameters. Alias for git rebase -i HEAD~<number of commits to go back>
function gri () {
    if [ "${1}" -eq  "" ] ; then
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



