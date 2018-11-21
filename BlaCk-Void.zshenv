# if running bash
if [ -n "$ZSH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.zshrc" ]; then
        . "$HOME/.zshrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$PATH:$HOME/bin"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$PATH:$HOME/.local/bin"
fi

if [ -d "$HOME/.cargo/bin" ] ; then
    export PATH="$PATH:$HOME/.cargo/bin"
    alias exa-grid='exa --long --grid'
    alias exa-tree='exa --long --tree'
fi

if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$PATH:$HOME/.local/bin"
fi

if [ -d "/home/linuxbrew/.linuxbrew/bin" ] ; then
    export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
fi

if [ -d "/snap/bin" ] ; then
    export PATH="$PATH:/snap/bin"
fi
