echo "----------------------------------------"
echo "         BlaCk-Void Zsh Setup"
echo "----------------------------------------"
BVZSH=$( cd "$(dirname "$0")" ; pwd )

echo ""
echo "--------------------"
echo "  Downloads"
echo ""
sudo apt-get install zsh zshdb autojump powerline curl python3-dev python3-pip shellcheck
sudo pip3 install thefuck
curl -L git.io/antigen > $BVZSH/antigen.zsh
git clone https://github.com/paoloantinori/hhighlighter.git $BVZSH/hhighlighter
wget -P $BVZSH https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
if [ -d "/home/linuxbrew/.linuxbrew/bin" ] ; then
  export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
fi
brew install fzf ripgrep
$(brew --prefix)/opt/fzf/install

echo "--------------------"
echo "  Fonts Settings"
echo ""
source $BVZSH/install_font.sh

echo "--------------------"
echo "  Apply Settings"
echo ""
zshrc=~/.zshrc
if [ -e $zshrc ]
then
  echo "$zshrc found."
  echo "Now Backup.."
  cp -v $zshrc $zshrc.bak
else
  echo "$zshrc not found."
fi
zshenv=~/.zshenv
if [ -e $zshenv ]
then
    echo "$zshenv found."
    echo "Now Backup.."
    cp -v $zshenv $zshenv.bak
else
    echo "$zshenv not found."
fi

sudo chsh -s /usr/bin/zsh # chsh $USER -s $(which zsh);

echo "source $BVZSH/BlaCk-Void.zshrc"  >> $zshrc
echo "source $BVZSH/BlaCk-Void.zshenv" >> $zshenv
#cp -v BlaCk-Void.zshrc  $file
echo "Please relogin session or restart terminal"
echo "The End!!"
echo ""
echo "command: zsh-help"
echo "for BlaCk-Void Zsh update"
