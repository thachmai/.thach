source /Users/thach.mai/.bootstrap_rc
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/thach/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias sinit='source <(ssh-agent); ssh-add'
alias ll='ls -la'
alias -g b01="46.101.175.226"
alias web='python3 -m http.server'

source <(fzf --zsh)

# Prompt stuff
#autoload -U promptinit
#promptinit
autoload -U colors && colors
PS1=[%{$fg[green]%}%/%{$reset_color%}]' '

# ssh agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi


# Go
export GOPATH=$HOME/dev/go

set editing-mode vi
bindkey "^R" history-incremental-search-backward


export PATH=$PATH:/usr/local/go/bin:$HOME/bin:/Users/thach.mai/dev/go/bin
export SHELL=$(which zsh)
export EDITOR=/usr/bin/vim

# Local specific settings should be stored in the file "local"
source ~/.thach/local

function repo_branch { git symbolic-ref HEAD 2> /dev/null | cut -d'/' -f3 }
function repo_name { basename `git rev-parse --show-toplevel 2> /dev/null` 2> /dev/null } 
setopt prompt_subst
RPROMPT=%{$fg[magenta]%}%n@%m%{$reset_color%}
RPROMPT='%{$fg[yellow]%}$(repo_branch) %{$fg_bold[yellow]%}$(repo_name)%{$reset_color%}'

function fix_gnome_workspace { gsettings set org.gnome.shell.overrides workspaces-only-on-primary false }

function ts {
    args=$@
    tmux send-keys -t right "$args" C-m
}

# encrypt/decrypt a file with gpg AES256 using gpg
# by default the encrypted file name will end with .gpg
function aesenc {
    gpg --symmetric --cipher-algo AES256 $1
}
function aesdec {
   gpg -o $2 -d $1.gpg
}
# securely view the file encrypted with "aesenc"
function secview {
    fbname=$(basename $1)
    sudo mount -t tmpfs -o size=10G thach_sec_ram ~/.thach/sec_ram
    aesdec $1 ~/.thach/sec_ram/$fbname
    emacs ~/.thach/sec_ram/$fbname 
    sudo umount ~/.thach/sec_ram
}
function secedit {
    fbname=$(basename $1)
    sudo mount -t tmpfs -o size=10G thach_sec_ram ~/.thach/sec_ram
    aesdec $1 ~/.thach/sec_ram/$fbname
    emacs ~/.thach/sec_ram/$fbname 
    aesenc ~/.thach/sec_ram/$fbname
    cp ~/.thach/sec_ram/$fbname.gpg $1.gpg
    sudo umount ~/.thach/sec_ram
}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NODE_EXTRA_CA_CERTS="$HOME/.config/nexus-npm/npm-sfdc-certs.pem"
