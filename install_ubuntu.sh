#!/bin/sh
set -e
if [ ! $PASSWORD ] && [ `who am i | awk '{print $1}'` = "vagrant" ]; then \
  PASSWORD="vagrant";
fi;

echo "-----------------------------------------------------";
echo " Set Swapfile";
echo "-----------------------------------------------------";
if [ `free -m | grep Swap | awk '{print $4}'` = 0 ];then \
  sudo dd if=/dev/zero of=/swapfile bs=1024K count=512;
  sudo mkswap /swapfile;
  sudo swapon /swapfile;
  sudo echo "/swapfile               swap                    swap    defaults        0 0" | sudo tee -a /etc/fstab
fi;

echo "-----------------------------------------------------";
echo " Update & install libraries";
echo "-----------------------------------------------------";
sudo apt-get -y update
sudo apt-get -y install git curl zsh tig make gcc dstat wget
sudo apt-get -y install tmux yarn
sudo apt-get -y install luajit libssl-dev libcurl4-openssl-dev autoconf
sudo apt-get -y install liblua5.2-dev lua5.2 python-dev ncurses-dev
sudo apt-get -y install mercurial gettext libncurses5-dev libxmu-dev libgtk2.0-dev libperl-dev python-dev python3-dev ruby-dev tcl-dev
sudo apt-get -y install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt-get -y update
sudo apt-get -y install neovim
sudo apt-get -y install python-dev python-pip python3-dev python3-pip

cd /tmp
wget https://github.com/jhawthorn/fzy/releases/download/0.9/fzy_0.9-1_amd64.deb
sudo dpkg -i fzy_0.9-1_amd64.deb
cd ~/

echo "-----------------------------------------------------";
echo "Install universal-ctags"
echo "-----------------------------------------------------";
cd /tmp/
git clone --depth 1 https://github.com/universal-ctags/ctags.git
cd ctags;
./autogen.sh && ./configure && make && sudo make install;
cd ~/

echo "-----------------------------------------------------";
echo " Setup my env";
echo "-----------------------------------------------------";
git clone https://github.com/tarjoilija/zgen.git ~/.zgen
git clone https://github.com/ktrysmt/dotfiles  ~/dotfiles
mkdir -p ~/.config/peco/
ln -s ~/dotfiles/.config/peco/config.json ~/.config/peco/config.json
ln -s ~/dotfiles/.zshenv ~/.zshenv
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.tigrc ~/.tigrc
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.tern-project ~/.tern-project
cp ~/dotfiles/.gitconfig ~/.gitconfig
echo "wget -O ~/.zgen/zsh-users/zsh-completions-master/src/_docker https://raw.githubusercontent.com/docker/docker/master/contrib/completion/zsh/_docker" | zsh
echo "wget -O ~/.zgen/zsh-users/zsh-completions-master/src/_docker-compose https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose" | zsh
cd ~/
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "-----------------------------------------------------";
echo "Install Vim with lua";
echo "-----------------------------------------------------";
mkdir /tmp/dotfiles
cd /tmp/dotfiles
git clone https://github.com/vim/vim
cd vim;
./configure \
 --enable-multibyte \
 --with-features=huge \
 --enable-luainterp \
 --enable-multibyte \
 --disable-selinux \;
make && sudo make install

echo "-----------------------------------------------------";
echo "Install Rust";
echo "-----------------------------------------------------";
cd /tmp/dotfiles
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env
cargo install ripgrep
cargo install --git https://github.com/sharkdp/fd
cargo install --no-default-features --git https://github.com/ogham/exa

echo "-----------------------------------------------------";
echo "Install Golang";
echo "-----------------------------------------------------";
mkdir -p ~/project/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$HOME/project/bin:$PATH
export GOPATH=$HOME/project

echo "-----------------------------------------------------";
echo "Install NodeJS";
echo "-----------------------------------------------------";
cd ~/;
curl -L git.io/nodebrew | perl - setup
~/.nodebrew/nodebrew install-binary stable
~/.nodebrew/nodebrew use stable

echo "-----------------------------------------------------";
echo "Neovim";
echo "-----------------------------------------------------";
sudo easy_install3 pip
sudo easy_install-2.7 pip
sudo pip2 install neovim
sudo pip3 install neovim
ln -sf $(which nvim) /usr/local/bin/vim

echo "-----------------------------------------------------";
echo "Setup Other";
echo "-----------------------------------------------------";
git clone https://github.com/syndbg/goenv.git ~/.goenv
go get github.com/peco/peco/cmd/peco
go get github.com/motemen/ghq
curl https://glide.sh/get | sh
vim +":PlugInstall" +":setfiletype go" +":GoInstallBinaries" +":PythonSupportInitPython2" +":PythonSupportInitPython3" +qa
npm install -g npm-check-updates
echo $PASSWORD | chsh -s /bin/zsh


