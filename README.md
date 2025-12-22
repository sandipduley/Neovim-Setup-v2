# 🌟 Neovim Setup v2

A fast, modern, and highly customized Neovim configuration optimized for
development.\
This setup includes **LSP support, syntax highlighting, fuzzy finding,
formatting, linting**, and various quality-of-life enhancements.

---

## 📌 Requirements

You need **Neovim version above 0.10.x**.\
Some plugins do not work well below **0.11.x**.

If your version is lower, build Neovim from source:\
https://github.com/neovim/neovim/blob/master/INSTALL.md

### ✔️ Required

1.  **Neovim** version **above 0.11.x**
2.  **lua 5.4**
3.  **luarocks**
4.  **LuaJIT**
5.  **Nerd Fonts**
6.  **ripgrep**
7.  **fzf**
8.  **go -- optional**
9.  **python3**
10. **nodejs**
11. **npm**
12. **clang**
13. **gcc**
14. **make**
15. **cmake**
16. **shellcheck**

---

## 📦 Install VsCode LSP Servers

```bash
npm install -g vscode-langservers-extracted
```

---

## 📦 Install GO Tools -- Only needed when you are working with golang

```bash
go install golang.org/x/tools/cmd/goimports@latest
go install mvdan.cc/gofumpt@latest
go install honnef.co/go/tools/cmd/staticcheck@latest

```

---

## ⚙️ You can install more LSP Servers, Formatter or Linter using Mason

```bash
:Mason
```

---

## 🔌 Installation

```bash
rm -rf ~/.config/nvim

git clone --depth=1 https://github.com/sandipduley/Neovim-Setup.git

cd Neovim-Setup

cp -r nvim/ ~/.config/nvim/
```

---

## 🐋 Docker

```bash
docker run -it --name custom-name sandipduley/neovim /bin/bash
```

---

## 📁 Neovim Folder Structure

            nvim
            ├── init.lua
            ├── lazy-lock.json
            ├── lazyvim.json
            └── lua
                ├── core
                │   ├── keymaps.lua
                │   ├── options.lua
                │   └── snippets.lua
                └── plugins
                    ├── alpha.lua
                    ├── autocompletion.lua
                    ├── bufferline.lua
                    ├── cmp.lua
                    ├── colortheme-switcher.lua
                    ├── comments.lua
                    ├── debug.lua
                    ├── extra-plugins.lua
                    ├── gitsigns.lua
                    ├── indent-blankline.lua
                    ├── lazygit.lua
                    ├── lsp.lua
                    ├── lualine.lua
                    ├── extra-plugins.lua
                    ├── neotree.lua
                    ├── none-ls.lua
                    ├── telescope.lua
                    ├── tiny-inline-diagnostic.lua
                    ├── treesitter.lua
                    ├── undotree.lua
                    └── yazi.lua

### 4 directories, 26 files

---

## 🚧 Issue

#### Failed to install ruff || python-lsp-server

###### Arch

```bash
sudo pacman -Sy python3 pipx

pipx install python-lsp-server
```

###### Ubuntu

```bash
sudo apt install python3 pipx

pipx install python-lsp-server
```

###### Fedora

```bash
sudo dnf install python3-lsp-server
```

#### clone failed -- could not resolve host : github

```bash
1.  Check your internet connections
2.  Close and re-open neovim this will probalbly solve the issue
```
