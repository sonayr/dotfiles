#!/bin/bash
# Install Home Brew
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install  brew apps
# xargs brew install < ./brew.txt

STOW_PACKAGES=("nvim" "zsh" "scripts" "LSP" "tmux" "iterm" "aerospace" "opencode" "claude")
# Create symlink for neovim search
ln -h -f -s "$PWD" "$HOME/dotfiles"
for folder in ${STOW_PACKAGES[@]}; do
    echo "stowing package $folder"
    stow -t $HOME -D $folder
    stow -t $HOME $folder
done

# Sync secrets if LastPass CLI is available
if command -v lpass >/dev/null 2>&1; then
    echo "Syncing secrets via LastPass..."
    "$HOME/.local/bin/sync-secrets" || echo "Note: Run 'sync-secrets' manually after logging in with 'lpass login'."
else
    echo "Tip: Install lastpass-cli ('brew install lastpass-cli') and run 'sync-secrets' to populate ~/.zsh_secrets"
fi
