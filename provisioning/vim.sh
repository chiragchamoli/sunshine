#!/usr/bin/env bash

echo ">>> Setting up Vim"


# Create directories needed for some .vimrc settings
mkdir -p /home/vagrant/.vim/backup
mkdir -p /home/vagrant/.vim/swap

# Install Vundle and set owner of .vim files
git clone https://github.com/gmarik/vundle.git /home/vagrant/.vim/bundle/vundle
sudo chown -R vagrant:vagrant /home/vagrant/.vim

# Grab .vimrc and set owner 
# vimrc at chirag
curl --silent -L https://gist.githubusercontent.com/chiragchamoli/cd9e797c583405354867/raw/2ebda0dcd8d4c4c197ff4e654b831ca78c6d1848/vimrc > /home/vagrant/.vimrc
sudo chown vagrant:vagrant /home/vagrant/.vimrc

# Install Vundle Bundles
sudo su - vagrant -c 'vim +BundleInstall +qall'
echo "√ Vim Installed"
