# lunarvim-configs

The configs I use with lunarvim.

## Installation

`make install`

This overrides your `$HOME/.config/lvim/config.lua` so you might want to make a backup.

## Soft Dependencies

- Node Version Manager (nvm), and an installed version of node that is specified in config.lua
    - Tree-sitter requires node 14 or newer, and the nvm default is sometimes older than that.
    - Not having this shouldn't cause any problems, it just adds a directory to lvim's PATH.
- Prettierd
    - `prettier` is configured to use `prettierd`, which is faster
