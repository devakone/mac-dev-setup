#!/bin/bash

# Create a folder who contains downloaded things for the setup
INSTALL_FOLDER=~/.macsetup
mkdir -p $INSTALL_FOLDER
MAC_SETUP_PROFILE=$INSTALL_FOLDER/macsetup_profile

# install brew
if ! hash brew
then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
else
  printf "\e[93m%s\e[m\n" "You already have brew installed."
fi

# CURL / WGET
brew install curl
brew install wget

{
  # shellcheck disable=SC2016
  echo 'export PATH="/usr/local/opt/curl/bin:$PATH"'
  # shellcheck disable=SC2016
  echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"'
  # shellcheck disable=SC2016
  echo 'export PATH="/usr/local/opt/sqlite/bin:$PATH"'
}>>$MAC_SETUP_PROFILE

# git
brew install git                                                                                      # https://formulae.brew.sh/formula/git
# github cli
brew install gh                                                                                      # https://formulae.brew.sh/formula/gh
# Adding git aliases (https://github.com/thomaspoignant/gitalias)
git clone https://github.com/thomaspoignant/gitalias.git $INSTALL_FOLDER/gitalias && echo -e "[include]\n    path = $INSTALL_FOLDER/gitalias/.gitalias\n$(cat ~/.gitconfig)" > ~/.gitconfig

#Interactive rebase tool
brew install interactive-rebase-tool
# Git Delta
brew install git-delta

# brew install git-secrets                                                                              # git hook to check if you are pushing aws secret (https://github.com/awslabs/git-secrets)
# git secrets --register-aws --global
# git secrets --install ~/.git-templates/git-secrets
# git config --global init.templateDir ~/.git-templates/git-secrets

# ZSH
brew install zsh zsh-completions                                                                      # Install zsh and zsh completions
sudo chown -R $(whoami) /usr/local/share/zsh /usr/local/share/zsh/site-functions
chmod u+w /usr/local/share/zsh /usr/local/share/zsh/site-functions
{
  echo "if type brew &>/dev/null; then"
  echo "  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH"
  echo "  autoload -Uz compinit"
  echo "  compinit"
  echo "fi"
} >>$MAC_SETUP_PROFILE

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"# Install oh-my-zsh on top of zsh to getting additional functionality
# Terminal replacement https://www.iterm2.com
brew cask install iterm2
# Pimp command line
brew install micro                                                                                    # replacement for nano/vi
brew install lsd                                                                                      # replacement for ls
{
  echo "alias ls='lsd'"
  echo "alias l='ls -l'"
  echo "alias la='ls -a'"
  echo "alias lla='ls -la'"
  echo "alias lt='ls --tree'"
} >>$MAC_SETUP_PROFILE

brew install tree
brew install ack
brew install bash-completion
brew install jq
brew install htop
brew install tldr
brew install coreutils
brew install watch

brew install z
touch ~/.z
echo '. /usr/local/etc/profile.d/z.sh' >> $MAC_SETUP_PROFILE

brew install ctop

# fonts (https://github.com/tonsky/FiraCode/wiki/Intellij-products-instructions)
brew tap homebrew/cask-fonts
brew cask install font-jetbrains-mono
brew cask install font-fira-code

# Browser
brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install firefox
brew cask install microsoft-edge

# Music / Video
brew cask install spotify
brew cask install vlc

# Productivity
brew cask install evernote                                                                            # cloud note
brew cask install kap                                                                                 # video screenshot
brew cask install rectangle                                                                           # manage windows

# Communication
brew cask install slack
brew cask install whatsapp
brew cask install telegram
brew cask install microsoft-teams

# Dev tools
brew cask install ngrok                                                                               # tunnel localhost over internet.
brew cask install postman                                                                             # Postman makes sending API requests simple.

# IDE
#brew cask install jetbrains-toolbox
brew cask install intellij-idea
brew cask install visual-studio-code
brew cask install android-studio

# Language

## Node / Javascript
mkdir ~/.nvm
brew install nvm    
{
  echo "export NVM_DIR=\"$HOME/.nvm\""
  echo 'source $(brew --prefix nvm)/nvm.sh'

}>>.zshrc   
exec /bin/zsh                                                                           
nvm install node                                                                                     # "node" is an alias for the latest version
nvm install 12
nvm install 10
nvm use 12
brew install yarn
brew uninstall node --ignore-dependencies
mkdir /usr/local/Cellar/node
ln -s ~/.nvm/versions/node/$(nvm current)/ /usr/local/Cellar/node
brew link --overwrite node
brew cleanup
brew doctor
# Consult https://github.com/nijicha/install_nodejs_and_yarn_homebrew for upgrade instructions

# Java
brew cask install java
brew install jenv
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(jenv init -)"' >> ~/.zshrc
#echo 'alias jenv_set_java_home='export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"''
exec /bin/zsh
echo 'jenv enable-plugin export' >> ~/.zshrc
echo 'jenv enable-plugin maven' >> ~/.zshrc
exec /bin/zsh
jenv doctor
brew cask install AdoptOpenJDK/openjdk/adoptopenjdk{8,11}
jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home

jenv global 11.0

brew install maven
brew install gradle


# Tomcat
brew install tomcat@8


## golang
{
  echo "# Go development"
  echo "export GOPATH=\"\${HOME}/.go\""
  echo "export GOROOT=\"\$(brew --prefix golang)/libexec\""
  echo "export PATH=\"\$PATH:\${GOPATH}/bin:\${GOROOT}/bin\""
}>>$MAC_SETUP_PROFILE
brew install go

## python
echo "export PATH=\"/usr/local/opt/python/libexec/bin:\$PATH\"" >> $MAC_SETUP_PROFILE
brew install python
if ! hash pip
then
  pip3 install --user pipenv
  pip3 install --upgrade setuptools
  pip3 install --upgrade pip
else
  pip install --user pipenv
  pip install --upgrade setuptools
  pip install --upgrade pip
fi

brew install pyenv
# shellcheck disable=SC2016
echo 'eval "$(pyenv init -)"' >> $MAC_SETUP_PROFILE


## terraform
brew install terraform
terraform -v

# Databases
brew cask install dbeaver-community # db viewer
brew install libpq                  # postgre command line
brew link --force libpq
# shellcheck disable=SC2016
echo 'export PATH="/usr/local/opt/libpq/bin:$PATH"' >> $MAC_SETUP_PROFILE
brew install mysql
brew services start mysql
brew cask install mysqlworkbench

# SFTP
brew cask install cyberduck

# Docker
brew cask install docker
brew install bash-completion
brew install docker-completion
brew install docker-compose-completion
brew install docker-machine-completion

# AWS command line
brew install awscli # Official command line
pip3 install saws    # A superchaip install --upgrade setuptools

# Google Drive and Dropbox
brew cask install google-backup-and-sync
brew cask install dropbox

# TunnelBlick
brew cask install tunnelblick

#Zoom
brew cask install zoomus

# Keybase
brew cask install keybase

#Genymotion
brew cask install genymotion

# Figma
brew cask install figma

# Office
brew cask install microsoft-office


# reload profile files.
{
  echo "source $MAC_SETUP_PROFILE # alias and things added by mac_setup script"
}>>"$HOME/.zsh_profile"
# shellcheck disable=SC1090
source "$HOME/.zsh_profile"

{
  echo "source $MAC_SETUP_PROFILE # alias and things added by mac_setup script"
}>>~/.bash_profile
# shellcheck disable=SC1090
source ~/.bash_profile
