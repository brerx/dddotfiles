# dotfiles

My dotfiles.

## Installation

### Full version

    /usr/bin/env ruby -e "$(curl -Ls https://raw.githubusercontent.com/\
    tklepzig/dotfiles/master/setup.rb)"

### Basic version

    /usr/bin/env ruby -e "$(curl -Ls https://raw.githubusercontent.com/\
    tklepzig/dotfiles/master/setup.rb)" -- --basic

## Setup asdf

See `# setup-asdf`.

## Themes

See `# set-theme`.

## Using Neovim

Set the environment variable DOTFILES_NVIM.  
It must be set before the dotfiles stuff is sourced.  
For example:

    export DOTFILES_NVIM=1

## TODO (WIP)

- overrides usage
- toolbox scripts, info.yaml, additional.yaml
- toolbox includes
- .dotfiles-local/plugins.vim
- .dotfiles-local/post-install
