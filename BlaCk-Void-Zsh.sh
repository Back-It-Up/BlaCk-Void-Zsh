#!/bin/bash
echo "----------------------------------------"
echo "         BlaCk-Void Zsh Setup"
echo "----------------------------------------"
set -e
BVZSH=$( cd "$(dirname "$0")" ; pwd )

echo ""
echo "--------------------"
echo "  Downloads"
echo ""
ARH_PACKAGE_NAME="zsh autojump powerline curl git ruby-irb fzf ripgrep thefuck w3m wmctrl ack tmux xdotool"
DEB_PACKAGE_NAME="zsh autojump powerline curl git w3m-img wmctrl ack tmux xdotool"
YUM_PACKAGE_NAME="zsh autojump powerline curl git w3m-img wmctrl ack tmux xdotool"
MAC_PACKAGE_NAME="zsh autojump curl python git socat w3m wmctrl ack tmux xdotool"
BSD_PACKAGE_NAME="zsh autojump py36-powerline-status curl git fzf ripgrep thefuck w3m-img xdotool p5-ack tmux xdotool"

arh_install()
{
  sudo pacman -Sy
  yes | sudo pacman -S $ARH_PACKAGE_NAME
}
deb_install()
{
  sudo apt-get update
  sudo apt-get install -y $DEB_PACKAGE_NAME
}
yum_install()
{
  #sudo yum check-update ##BUG: Return from Fedora??
  sudo yum install -y $YUM_PACKAGE_NAME
}
mac_install()
{
  brew update
  brew install $MAC_PACKAGE_NAME

  if ! [ -x "$(command -v pip)" ]; then
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py | sudo python get-pip.py
  fi
  sudo pip3 install powerline-status
}
bsd_install()
{
  sudo pkg update
  sudo pkg install -y $BSD_PACKAGE_NAME
}

set_brew()
{
  if ! [ -x "$(command -v brew)" ]; then
    echo "Now, Install Brew." >&2
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

      if [ -d "/home/linuxbrew/.linuxbrew/bin" ] ; then
        export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin/"
      fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      export PATH=$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH
    fi
  fi
  {
    brew install fzf ripgrep thefuck
  } || {
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    brew vendor-install ruby
    brew install fzf ripgrep thefuck
  }
  $(brew --prefix)/opt/fzf/install
}
etc_install()
{
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
  curl -L $BVZSH https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping > $BVZSH/prettyping
  chmod +x $BVZSH/prettyping
  source $BVZSH/install_font.sh
}

if   [[ "$OSTYPE" == "linux-gnu" ]]; then
  ##ARH Package
  if   cat /etc/*release | grep ^NAME    | grep Manjaro; then
    arh_install
  elif cat /etc/*release | grep ^NAME    | grep Chakra ; then
    arh_install
  elif cat /etc/*release | grep ^ID      | grep arch   ; then
    arh_install
  elif cat /etc/*release | grep ^ID_LIKE | grep arch   ; then
    arh_install

  ##Deb Package
  elif cat /etc/*release | grep ^NAME    | grep Ubuntu ; then
    ubuntu_ver=$(lsb_release -rs)
    if [[ ${ubuntu_ver:0:2} -lt 18 ]]; then
      DEB_PACKAGE_NAME=$( sed -e "s/ack/ack-grep/" <(echo $DEB_PACKAGE_NAME) )
    fi
    deb_install
  elif cat /etc/*release | grep ^NAME    | grep Debian ; then
    deb_install
  elif cat /etc/*release | grep ^NAME    | grep Mint   ; then
    deb_install
  elif cat /etc/*release | grep ^NAME    | grep Knoppix; then
    deb_install
  elif cat /etc/*release | grep ^ID_LIKE | grep debian ; then
    deb_install

  ##Yum Package
  elif cat /etc/*release | grep ^NAME    | grep CentOS ; then
    yum_install
  elif cat /etc/*release | grep ^NAME    | grep Red    ; then
    yum_install
  elif cat /etc/*release | grep ^NAME    | grep Fedora ; then
    yum_install
  elif cat /etc/*release | grep ^ID_LIKE | grep rhel   ; then
    yum_install

  else
     echo "OS NOT DETECTED, couldn't install packages."
     exit 1;
  fi
  set_brew
elif [[ "$OSTYPE" == "darwin"*  ]]; then
  set_brew
  mac_install
elif [[ "$OSTYPE" == "FreeBSD"* ]]; then
  bsd_install
elif uname -a | grep FreeBSD      ; then
  bsd_install
else
  echo "OS NOT DETECTED, couldn't install packages."
  exit 1;
fi

etc_install
source $BVZSH/install_font.sh

echo "--------------------"
echo "  Apply Settings"
echo ""

mkdir $BVZSH/cache
zshrc=~/.zshrc
zshenv=~/.zshenv
zlogin=~/.zlogin
zprofile=~/.zprofile

set_file()
{
  local file=$1
  echo "-------"
  echo "Set $file !!"
  echo ""
  if [ -e $file ]; then
    echo "$file found."
    echo "Now Backup.."
    cp -v $file $file.bak
    echo ""
  else
    echo "$file not found."
    touch $file
    echo "$file is created"
    echo ""
  fi
}
set_file $zshrc
set_file $zshenv
set_file $zlogin

echo "source $BVZSH/BlaCk-Void.zshrc"         >> $zshrc
echo "source $BVZSH/BlaCk-Void.zshenv"        >> $zshenv
echo "source $BVZSH/BlaCk-Void.zlogin"        >> $zlogin
cat ~/.profile                                | tee -a $zprofile
#cp -v BlaCk-Void.zshrc  $file

#Remove zplugin installer contents
if [[ "$OSTYPE" == "darwin"*  ]]; then
    sed -i '' "/[zZ]plugin/d" ~/.zshrc
else
    sed -i    "/[zZ]plugin/d" ~/.zshrc
fi

echo "-------"
echo "ZSH as the default shell(need sudo permission)"
chsh -s $(which zsh)

echo "Please relogin session or restart terminal"
echo "The End!!"
echo ""

echo "command: zsh-help"
echo "for BlaCk-Void Zsh update"
