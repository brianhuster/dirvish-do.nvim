# Introduction

> The file manipulation commands for [vim-dirvish](https://github.com/justinmk/vim-dirvish) that you've always wanted

# Features
- Supports most file operations: create, rename, copy, move, delete, move to trash
- Cross-platform support thanks to [luv](https://github.com/luvit/luv)
- Easy to memorize [mappings](#keymaps) 
- Integration with LSP for renaming files,...
- Netrw-styled `:Open` and `:Launch` commands (only in Nvim 0.10.1+)
- Sudo mode for operations that require elevated permissions

# Requirements

- Nvim 0.8 or later
- [dirvish.vim](https://github.com/justinmk/vim-dirvish)
- `sh` command for `sudo` mode (`:echo executable('sh')` should return 1)
- Optional : In case you want to move files to trash instead of deleting permanently (opts.operations.remove = "trash"):
    - Python3 provider for Neovim. `:echo has('python3')` should return 1. See `:h provider-python` for more information on how to set it up.
    - [send2trash](https://pypi.org/project/Send2Trash/)

# Installation

You can install this plugin using any plugin manager that supports GitHub repositories. Below are some examples:

Note: This plugin is lazy-loaded by default, so you don't need to worry about it slowing down your startup time.

## lazy.nvim 

```lua
{
    'brianhuster/dirvish-do.nvim', 
    --- No need to specify dependencies as lazy.nvim supports loading dependencies information from pkg.json
}
```

## mini.deps
```lua
MiniDeps.add({
    source = 'brianhuster/dirvish-do.nvim',
    depends = {
        'justinmk/vim-dirvish',
    },
})
```

## Vim-Plug

```vim
Plug 'justinmk/vim-dirvish'
Plug 'brianhuster/dirvish-do.nvim'
```

See [`:h dirvish-do`](doc/dirvish-do.txt) for more information on how to configure and use the plugin.

# Credit

This is a fork of [vim-dirvish-dovish](https://github.com/roginfarrer/vim-dirvish-dovish) by Rogin Farrer that has been rewritten in Lua. It uses `:h luv` and `:h builtin` Vim commands and functions instead of shell commands for better cross-platform support out of the box.

Thanks to [Anton Kavalkou](https://github.com/antosha417/nvim-lsp-file-operations) for the inspiration and the idea to integrate with LSP

Big shout out to [Melandel](https://github.com/Melandel) for laying the [foundation](https://github.com/Melandel/desktop/blob/c323969e4bd48dda6dbceada3a7afe8bacdda0f5/setup/my_vimrc.vim#L976-L1147) for this plugin!
