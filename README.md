# Liam's Dotfiles

## Add these dotfiles to your machine
First remove or backup your existing dots.
```sh
// remove
rm -rf .zshrc .config/nvim .config/ghostty

// or backup
mv .zshrc .zshrc.bak
mv .config/nvim .config/nvim.bak
mv .config/ghostty .config/ghostty.bak
```

Pull latest `main`.

```sh
cd dotfiles && stow zsh nvim ghostty
```

## Add/Update your dotfiles to this repo
To add, move your dotfile and its relative path to the dotfiles repo e.g.
```
mv ~/.config/nvim ~/dotfiles/nvim/.config/nvim
```

Commit and push to `main`.

To update, just change your configs as you would normally and keep `main` updated.

