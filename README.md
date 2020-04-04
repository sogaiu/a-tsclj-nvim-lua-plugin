# a-tsclj-nvim-lua-plugin

Quick demo of using tree-sitter-clojure to highlight code in neovim (>= 0.5)

## Prerequisites

* neovim (>= 0.5)
* tree-sitter-clojure

## Prepare

* Install neovim (>= 0.5) or rather the master branch of neovim as 0.5
  is not released yet.

* Follow the instructions through "Initial Setup" step of
  [tree-sitter-clojure](https://github.com/sogaiu/tree-sitter-clojure).
  Note, you likely won't need emsdk.

* From the tree-sitter-clojure directory that was cloned, parse
  clojure.core (assuming clojure source lives under ~/src):

  ```
  $ npx tree-sitter parse ~/src/clojure/src/clj/clojure/core.clj
  ```

This should have prepared a `~/.tree-sitter` directory and copied a
`clojure.so` (or .dynlib or .dll) file to live under
`~/.tree-sitter/bin`.

The vim runtimepath is used to locate the .so|.dynlib|.dll.  This can
be achieved in a variety of ways, but here is one way:

* Symlink `~/.tree-sitter/bin` to a place such as
  `~/.config/nvim/parser`.  Here `~/.config/nvim` is assumed to be on
  the vim runtimepath, substitute something else if this particular
  choice is undesirable.

* Clone this repository:

  ```
  $ git clone https://github.com/sogaiu/a-tsclj-nvim-lua-plugin
  ```

* Start neovim with the cloned directory on the vim runtime path:

  ```
  nvim --cmd "set rtp+=./a-tsclj-nvim-lua-plugin"
  ```

* Turn off syntax highlighting:

  ```
  :syntax off
  ```

* Open clojure.core:

  ```
  :edit ~/src/clojure/src/clj/clojure/core.clj
  ```

The file should look pretty plain (as in, color-less).

## Demo

* Use tree-sitter-clojure to highlight the buffer by entering
  `<M-C-H>` (see `plugin/a-tsclj-nvim-lua-plugin.vim` if another key
  sequence needs to be used).  Alternatively, one can `:lua
  trsi:highlight_clojure()<CR>`.

The text `tree-sitter-clojure detected` should appear at the bottom of
the screen if all went well, and the buffer should now have more color
in it.

## Hacking

* Tweaking of highlighting can be done by editing the value of
  `default_query` in `lua/trsiclj/init.lua`.

## Thanks

* jacobsimpson - nvim-example-lua-plugin 
* SevereOverfl0w - tree-sitter and vim info
