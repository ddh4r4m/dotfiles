
# 1. Faster Completion (Only check once a day)
autoload -U compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m-1) ]]; then
  compinit -C
else
  compinit
fi

# 2. Lazy-load NVM (This removes the 400ms delay)
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"
  nvm "$@"
}
node() { unset -f node npm nvm; nvm use default; node "$@" }
npm() { unset -f node npm nvm; nvm use default; npm "$@" }

# 3. Prompt & Tool Init (Keep these, but avoid multiple evals)
#eval "$(starship init zsh)"
# Replace: eval "$(starship init zsh)"
# With this (faster):
# source <(starship init zsh --print-full-init)
# starship init zsh > ~/.starship_init.zsh
source ~/.starship_init.zsh

eval "$(zoxide init --cmd cd zsh)"
eval "$(fzf --zsh)"

# 4. Lazy-load 'thefuck'
fuck() {
  eval $(thefuck --alias fuck)
  fuck "$@"
}

# 5. Manual plugin loading
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# 6. Vi mode & Keybindings
bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# 7. Path & Exports (Grouped for clarity)
export ANDROID_HOME=$HOME/Library/Android/sdk
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
path=(
  "/Users/dharamdhurandhar/.codeium/windsurf/bin"
  "$JAVA_HOME/bin"
  "$ANDROID_HOME/emulator"
  "$ANDROID_HOME/platform-tools"
  "$ANDROID_HOME/tools"
  "$ANDROID_HOME/tools/bin"
  "$HOME/.local/bin"
  $path
)

# 8. Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias claude-start='tmux new-session "claude --model claude-sonnet-4-6" \; split-window -h -p 30'

# 9. History Config
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory hist_ignore_all_dups hist_ignore_space


