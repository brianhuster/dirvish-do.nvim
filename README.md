# Introduction

> The file manipulation commands for [vim-dirvish](https://github.com/justinmk/vim-dirvish) that you've always wanted

# Features
- Supports most file operations: create, rename, copy, move, delete, move to trash
- Cross-platform support thanks to [luv](https://github.com/luvit/luv)
- Easy to memorize [mappings](#mappings) 
- Integration with LSP for renaming files,...

# Requirements

- Nvim 0.8 or later
- [dirvish.vim](https://github.com/justinmk/vim-dirvish)
- Optional : if you use move-to-trash feature
    - You need to install Python3 provider for Neovim. You can check if `:echo has('python3')` returns 1 to knwo whether Python3 provider is installed. See `:h provider-python` for more information
    - You also need to install Python library [send2trash](https://pypi.org/project/Send2Trash/)

# Installation

You can install this plugin using any plugin manager that supports GitHub repositories. Below are some examples:

## lazy.nvim 

```lua
{
    'brianhuster/dirvish-do.nvim',
    dependencies = {'justinmk/vim-dirvish'}
}
```
## Vim-Plug

```vim
Plug 'justinmk/vim-dirvish'
Plug 'brianhuster/dirvish-do.nvim'
```
# Configuration

You can configure the keymaps to your liking. Below is default configuration:

## In Lua

```lua
require('dirvish-do').setup({
    operations = {
        remove = "permanent", -- Change to "trash" if you want to move to trash instead of deleting permanently
    },
	keymaps = {
		make_file = 'mf',
		make_dir = 'md',
		copy = 'cp',
		move = 'mv',
		rename = 'r',
		remove = '<Del>',
	},
})
```

## In Vimscript

You can use `v:lua` to call the Lua function from Vimscript:

```vim
call v:lua.require'dirvish-do'.setup(
    \ " Config dictionary goes here
\ )
```
See `:h v:lua-call` for more information.

# Usage

## Keymaps

Below are the default keymaps. You can change them in the [configuration](#configuration)

| Function                                | Default | Mode  |Tip to remember             |
| --------------------------------------- | ------- | ----  |----------------------------|
| Create file                             | `mf`    | Normal|`mf` for "make file"        |
| Create directory                        | `md`    | Normal|`md` for "make directory"   |
| Delete under cursor                     | `<Del>` | Normal|Just delete key             |
| Delete items in visual selection        | `<Del>` | Visual|Just delete key             |
| Rename under cursor                     | `r`     | Normal|`r` for "rename"            |
| Copy file to current directory          | `cp`    | Normal|`cp` for "copy"             |
| Move file to current directory          | `mv`    | Normal|`mv` for "move"             |

For example, you can use `yy` to yank a file, then move to a new directory and use `p` to paste the file there. Or to move a file, you use `yy` to yank the file, move to a new directory and use `mv` to move the file there.

You can also use `y` in `visual line` mode to select many files to copy or move. (Note: `visual line` mode is recommended so that you can yank the full file path)

## Tips

- Run `:h dirvish-do` to see the help file generated from this README
- Use `:checkhealth dirvish-do` to check your keymaps and configuration

# Credit

This is a fork of [vim-dirvish-dovish](https://github.com/roginfarrer/vim-dirvish-dovish) by Rogin Farrer that has been rewritten in Lua. It uses `:h luv` and `:h builtin` Vim commands and functions instead of shell commands for better cross-platform support out of the box.

Thanks to [Anton Kavalkou](https://github.com/antosha417/nvim-lsp-file-operations) for the inspiration and the idea to integrate with LSP

Big shout out to [Melandel](https://github.com/Melandel) for laying the [foundation](https://github.com/Melandel/desktop/blob/c323969e4bd48dda6dbceada3a7afe8bacdda0f5/setup/my_vimrc.vim#L976-L1147) for this plugin!
