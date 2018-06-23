echo "----------------------------------------"
echo "         BlaCk-Void Zsh Setup"
echo "----------------------------------------\n"
BVZSH=$( cd "$(dirname "$0")" ; pwd )

echo "--------------------"
echo "  Downloads\n"
sudo apt-get install zsh zshdb autojump powerline curl python3-dev python3-pip shellcheck
sudo pip3 install thefuck
curl -L git.io/antigen > antigen.zsh
git clone https://github.com/paoloantinori/hhighlighter.git $BVZSH/

echo "--------------------"
echo "  Fonts Settings\n"
git clone https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts && ./install.sh
cd ..

echo "--------------------"
echo "  Apply Settings\n"
file=~/.zshrc
if [ -e $file ]
then
  echo "$file found."
  echo "Now Backup.."
  mv -v ~/.zshrc ~/.zshrc.backup
else
  echo "$file not found."
fi
sudo chsh -s /usr/bin/zsh # chsh $USER -s $(which zsh);

echo "source $BVZSH/BlaCk-Void.zshrc" >> ~/.zshrc
#cp -v BlaCk-Void.zshrc  ~/.zshrc
echo "Please relogin session or restart terminal"
echo "The End!!"
