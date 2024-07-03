# FunkTree

<h1 align="center">
<img src="logo.png" width="180">
</h1><br>

The **FunkTree** plugin simplifies navigation through objects and key structures in files.
It's based on the awesome [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim/tree/master) plugin
that works as a frontend for the parsing result of the analyzed file.

Currently, *FunkTree* works with: 

| Language   | Level        |
|------------|--------------|
| Lua        | Basic        |
| Python     | Advanced     |
| JavaScript | Basic        |


*FunkTree* enable users to navigate for example among classes, methods, and functions within the open file.

<!-- ![](https://github.com/marcosalvalaggio/funktree/blob/main/demo.gif) -->


## Installation 

### Packer 

With [packer.nvim](https://github.com/wbthomason/packer.nvim)

 ```lua
 use("marcosalvalaggio/funktree")
 ``` 
remap command:

```lua
vim.api.nvim_set_keymap('n', '<leader>k', ':Funk<CR>', {noremap=true})
```

### Lazy

 With [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
  "marcosalvalaggio/funktree",
  dependencies = {"nvim-telescope/telescope.nvim"},
  config = function()
    vim.api.nvim_set_keymap('n', '<leader>k', ':Funk<CR>', {noremap=true})
  end
}
```

 ## Usage 

 FunkTree is composed by a single command: 

```vimscript
:Funk
```

The *:Funk* command opens a new buffer containing the names of the key structures present in the analyzed file.

Moving the cursor to the line in the FunkTree buffer and pressing "Enter" closes the FunkTree buffer and positions the cursor in the original buffer at the lines indicated as "line" in the FunkTree buffer. If you want to close the FunkTree buffer simply press **esc** on the keyboard.


