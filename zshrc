# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="cobalt2"

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

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
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

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
 fastfetch
alias android='waydroid session start && waydroid show-full-ui'
alias windowsten='qemu-system-x86_64 --enable-kvm -hda ~/.windows.qcow -m 10G -smp 4 -bios /usr/share/ovmf/x64/OVMF.fd'
alias temp='sensors && temp_celsius=$(cat /sys/class/thermal/thermal_zone0/temp) && echo "Temperature: $(($temp_celsius / 1000))°C"     '
luna() {
  if [ -z "$1" ]; then

    echo "Usage: luna <command> [options]"
    echo "Available commands:"
    echo "  help: Lists this page"
    echo "  install <package>: Install a package"
    echo "  update: Update package list"
    echo "  fulldate: Full system update"
    echo "  search <package>: Search for a package"
    echo "  remove <package>: Remove a package"
    echo "  hub <subcommand>: Interact with flathub (install and search)"
    echo "  info <package>: Shows information about a package"
    echo "  list: Shows all installed packages"
    echo "  depends <package>: Shows dependencies of a package"
    echo "  orphans: Lists all orphaned packages"
    echo "  orphandel: Deletes all orphaned packages"
  else
    case "$1" in
      help)
      echo "Usage: luna <command> [options]"
      echo "Available commands:"
      echo "  help: Lists this page"
      echo "  install <package>: Install a package"
      echo "  update: Update package list"
      echo "  fulldate: Full system update"
      echo "  search <package>: Search for a package"
      echo "  remove <package>: Remove a package"
      echo "  hub <subcommand>: Interact with flathub (install and search)"
      echo "  info <package>: Shows information about a package"
      echo "  list: Shows all installed packages"
      echo "  depends <package>: Shows dependencies of a package"
      echo "  orphans: Lists all orphaned packages"
      echo "  orphandel: Deletes all orphaned packages"
      ;;
      info) yay -Si "$@" ;;
      list) yay -Q ;;
      depends) yay -Qi "$@" ;;
      orphans) yay -Qdt ;;
      orphandel) yay -Rns $(yay -Qtdq) ;;
      install) shift; yay -S "$@" --needed ;;
      update) yay -Sy ;;
      fulldate) yay -Syu --noconfirm ;;
      search) shift; yay -Ss $@ ;;
      remove) shift; yay -R "$@"  ;;
      help)
      echo "Usage: luna <command> [options]"
      echo "Available commands:"
      echo "  help: Lists this page"
      echo "  install <package>: Install a package"
      echo "  update: Update package list"
      echo "  fulldate: Full system update"
      echo "  search <package>: Search for a package"
      echo "  remove <package>: Remove a package"
      echo "  info <package>: Shows information about a package"
      echo "  list: Shows all installed packages"
      echo "  depends <package>: Shows dependencies of a package"
      echo "  orphans: Lists all orphaned packages"
      echo "  orphandel: Deletes all orphaned packages"
     ;;
      hub)
        case "$2" in
          help)
          echo "Usage: luna hub <options>"
          echo "Available options:"
          echo "  help: Lists this page"
          echo "  install <app>: Installs a flatpak app"
          echo "  search <name>: Searchs flatpak for a app with that name or smilar"
          echo "  update: Updates flatpak apps"
          ;;
          install) shift; shift; flatpak install flathub "$@" ;;
          search) shift; flatpak search flathub "$@" --columns=all ;;
          update) shift; flatpak update ;;
          *) echo "Unknown subcommand: $2" ;;
        esac
      ;;
      *) echo "Unknown subcommand: $1" ;;
    esac
  fi
}

