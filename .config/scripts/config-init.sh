#!/usr/bin/env bash

git clone --bare git@github.com:liamrdawson/dotfiles.git $HOME/.dotfiles

# Define config alias locally since the dotfiles
# aren't installed on the system yet.
# Change path/to/,dotfiles as appropriate.
function config {
	git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

# Create a directory to backup existing dotfiles to
mkdir -p .dotfiles-backup
config checkout
if [ $? = 0 ]; then
	echo "Checked out dotfiles from git@github.com:liamrdawson/dotfiles.git"
else
	echo "Moving existing dotfiles to ~/.dotfiles-backup"
	config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi

# Checkout dotfiles from repo
config checkout
config config status.showUntrackedFiles no
