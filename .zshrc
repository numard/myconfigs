# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="candy "
# see source for powerlevel10k.theme below

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)


source $ZSH/oh-my-zsh.sh

# ZSH User configuration
# History config
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
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
# dont add to history commands starting with space 
setopt HIST_IGNORE_SPACE

# force emacs bindkeys for the line editor (somewhat more standard than vim mode...)
bindkey -e
unsetopt beep
setopt NO_CASE_GLOB
# revert to bash autocomplete behaviour
# setopt GLOB_COMPLETE
setopt AUTO_CD
# You may need to manually set your language environment
# export LANG=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=vim

# Compilation flags
export ARCHFLAGS="-arch x86_64"


alias ls="ls --color=never"
alias m8="sudo mtr 8.8.8.8"
alias dkc='docker compose'
alias dke='docker exec'
alias dki='docker image'
alias dkp='docker ps'
alias dkr='docker run'

# Many other git specific aliases added by oh-my-zsh
alias pc="pre-commit"
alias gfa='git fetch --all'
alias gpr='git pull --rebase; git log ORIG_HEAD..'
alias gca='git commit --amend'
alias gderp='git commit -m derp'
alias gw='git whatchanged'
alias gr='git rebase'
## gri - is a function
alias gl="/usr/bin/git log --date-order --graph --pretty=format:'%Cred%h%Creset %Cgreen(%ci)%Creset%  - %C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
# git tree
alias gt="git log --all --graph --decorate --oneline"
# git tree tags only
alias gtt="git log --graph --simplify-by-decoration --pretty=format:'%d' --all"

alias gback='git branch $(git rev-parse --abbrev-ref HEAD)-BACK-$(date +%Y%m%d-%H%M)'
alias agn="ag --nonumbers"

alias Grep="grep"
ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

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




source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
