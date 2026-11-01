# 1337 School Vim Setup

A highly optimized Vim configuration tailored for C development at 1337 school, focusing on "The Norm" and efficient workflow.

## 🚀 Features

- **Norm Compliance**: Strict indentation and formatting settings to pass Norminette.
- **Automatic Header**: Quick insertion of the 42/1337 project header.
- **Integrated Norminette**: Run the style checker directly from Vim.
- **Strict Compilation**: Pre-configured `makeprg` with \`-Wall -Wextra -Werror\`.
- **Plugin Powered**: Includes NERDTree, Vim-Airline, and more.

## 🛠️ Key Mappings

| Mapping | Action |
|----------|--------|
| \`<leader>H\` | Insert 1337 Project Header |
| \`<F5\` | Compile current C file (Strict flags) |
| \`<F6\` | Run Norminette on current file |
| \`<leader>e\` | Toggle NERDTree |
| \`<leader>w\` | Save file |
| \`<leader>q\` | Quit Vim |
| \`<leader>h\` | Clear search highlights |

## 📦 Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/AyoubMzian-Dev/vim-setup.git ~/vim-setup
   ```

2. Run the setup script:
   ```bash
   cd ~/vim-setup
   chmod +x setup.sh
   ./setup.sh
   ```

3. Open Vim and install plugins:
   ```vim
   :PlugInstall
   ```

## ⚙️ Configuration Structure

The configuration is modularized for readability:
- \`.vimrc\`: Main entry point.
- \`config/ui.vim\`: UI and appearance settings.
- \`config/editing.vim\`: General editing and search behaviors.
- \`config/c_norm.vim\`: 1337 school specific C settings and mappings.
- \`config/rust.vim\`: Rust language support.
- \`config/plugins.vim\`: Plugin management.