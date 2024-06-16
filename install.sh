#!/bin/bash

# Install Home Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install  brew apps
xargs brew install < ./brew.txt

stow . -t ~/


