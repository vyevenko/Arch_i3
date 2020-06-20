#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export BROWSER=/usr/bin/firefox
export EDITOR=/usr/bin/nano

# IK-TECH
export IK_PROJECTS=/home/vyeve/projects/ik-tech

# Kubernetes
source <(kubectl completion bash)
export KUBE_EDITOR=$EDITOR
export KUBECONFIG=$HOME/.kube/config

# Color terminal
	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
# Color bash
parse_git_branch() { 

git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' 

} 
PS1='\[\033[01;32m\]$(printf %s "$(date +%k:%M:%S)")@\u\[\033[00m\]:\[\033[01;33m\]\w\[\033[00m\]\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '


# SSH agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    #echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    #echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add "$HOME/.ssh/ik-tech_rsa";
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
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH