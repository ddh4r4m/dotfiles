# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system

### Git

```
pacman -S git
```

### Stow

```
pacman -S stow
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
$ git clone git@github.com/dreamsofautonomy/dotfiles.git
$ cd dotfiles
```

then use GNU stow to create symlinks

```
$ stow .
```

## Herdr Setup

Herdr is an agent-aware terminal multiplexer (tmux-like) used alongside Ghostty. Its config lives at `.config/herdr/` in this repo and gets symlinked to `~/.config/herdr/`.

1. Install herdr and Ghostty:

```
brew install herdr
brew install --cask ghostty
```

2. Stow this repo (if you haven't already) so `~/.config/herdr/config.toml` and `~/.config/herdr/status.sh` symlink in:

```
$ cd ~/dotfiles
$ stow .
```

3. Make sure the status bar script is executable (stow preserves permissions, but verify after a fresh clone):

```
chmod +x ~/.config/herdr/status.sh
```

4. Reload herdr's config without restarting the server:

```
herdr server reload-config
```

5. Fully quit and relaunch Ghostty at least once so `theme = TokyoNight Night` and other terminal-level settings take effect.

What's included:
- `theme.custom` — tokyo-night-matched colors for sidebar, panels, and text so nothing falls back to unreadable defaults
- `ui.sidebar.agents` / `ui.sidebar.spaces` — custom row layouts with `dim = false` on every token, since herdr auto-dims unfocused rows otherwise
- `ui.pane_borders` / `pane_gaps` / `show_agent_labels_on_pane_borders` — visible pane separation with agent names on borders
- `status.sh` — feeds a `load · battery` widget into the top-right status bar via `ui.tab_bar_right`

## Other Packages
```
brew install zoxide
```

```
brew install ripgrep
```

```
brew install fd
```

```
brew install tmux
```

```
brew install gh
```

```
brew install jq
```

```
brew install stow
```

```
brew install fzf
```

```
brew install thefuck
```

```
brew install herdr
brew install --cask ghostty
```

```
git clone https://github.com/zsh-users/zsh-completions.git \
  ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
```


# install tmux plugins
ctrl+s + I 
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```


```
Update your ~/.zshrc configuration before sourcing oh-my-zsh:
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit
source "$ZSH/oh-my-zsh.sh"
```

```
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
```


## Old Brew : All installed packages 
### List all packages and copy to clipboard
```
brew list --formula | pbcopy
```

### Install all brew packages

```
brew install 
abseil
adb-enhanced
aom
bazel
boost
brotli
c-ares
ca-certificates
cairo
cjson
cmake
cocoapods
docker
docker-completion
docker-compose
double-conversion
edencommon
fb303
fbthrift
fd
fizz
fmt
folly
fontconfig
freetype
fzf
gdbm
gettext
gflags
gh
giflib
git
git-lfs
glib
glog
go
grafana
graphite2
groonga
harfbuzz
highway
icu4c@76
icu4c@77
imagemagick
imath
jasper
jpeg-turbo
jpeg-xl
libde265
libdeflate
libevent
libgit2
libheif
libidn2
liblqr
libnghttp2
libomp
libpng
libraw
libsodium
libssh2
libtiff
libtool
libunistring
libuv
libvmaf
libwebsockets
libx11
libxau
libxcb
libxdmcp
libxext
libxrender
libyaml
little-cms2
llvm
lpeg
luajit
luv
lz4
lzo
m4
mariadb
mecab
mecab-ipadic
mint
mise
mosquitto
mpdecimal
msgpack
ncurses
neovim
nginx
node
nvm
openexr
openjdk@11
openjdk@17
openjdk@21
openjpeg
openssl@1.1
openssl@3
pcre2
pipx
pixman
pkgconf
protobuf
python@3.10
python@3.12
python@3.13
readline
redis
ripgrep
ruby
rust
sentencepiece
shared-mime-info
snappy
sqlite
starship
stow
swiftlint
telnet
thefuck
tmux
tree-sitter
unibilium
usage
utf8proc
wangle
watchman
webp
wget
x265
xcodegen
xorgproto
xxhash
xz
yarn
z3
zoxide
zsh-autosuggestions
zsh-syntax-highlighting
zstd
```