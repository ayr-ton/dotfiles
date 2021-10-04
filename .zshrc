source $HOME/antigen.zsh

# Use Oh-My-Zsh
antigen use oh-my-zsh

# Set theme
#antigen theme agnoster
antigen theme xiong-chiamiov-plus

antigen bundle ssh-agent

# Bundles from the default repo (robbyrussell's oh-my-zsh)
antigen bundle dotenv
antigen bundle git
antigen bundle pip
antigen bundle lein
antigen bundle python
antigen bundle command-not-found
antigen bundle ansible
antigen bundle docker
antigen bundle docker-compose
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting

# Apply changes
antigen apply

# Fix weird ^W bahaviour
bindkey  "^W"      vi-backward-kill-word
bindkey  "^[[1~"   beginning-of-line
bindkey  "^[[4~"   end-of-line

# Setup man PAGER and less settings. Use -X to avoid clearning screen
export LESS="-iMFXRj4a"
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal'

# Bash-like navigation
autoload -U select-word-style
select-word-style bash

# Source local customizations
source ~/.zshrc.local
