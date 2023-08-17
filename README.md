# FunkTree

The **FunkTree** plugin simplifies navigation through objects and key structures in files. It's self-contained, avoiding external dependencies or reliance on other plugins. 

Currently, FunkTree works exclusively with **Python** files, enabling users to navigate among classes, methods, and functions within the open file.

![](https://github.com/marcosalvalaggio/funktree/blob/main/demo.gif)


## Installation 

The [packer.nvim](https://github.com/wbthomason/packer.nvim) plugin manager is the only installation method that has been tested. However, theoretically, you can install **FunkTree** using your preferred package manager.

 ```lua
 use("marcosalvalaggio/funktree")
 ``` 

 ## Usage 

 FunkTree is composed by a single command: 

  ```vimscript
  :Funk
   ```

The **:Funk** command opens a new buffer containing the names of the key structures present in the analyzed Python file (classes, methods, and functions), as you can see in the demo.gif.

Moving the cursor to the line in the FunkTree buffer and pressing "Enter" closes the FunkTree buffer and positions the cursor in the original buffer at the lines indicated as "line" in the FunkTree buffer. If you want to close the FunkTree buffer simply press **q** on the keyboard.




