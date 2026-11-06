# TASK
create a vim/nvim for a 42/1337 student. It makes Vim behave like VSCode in a terminal and helps with the 42 Norm. Deliver full vim/nvim setup. Work incrementally, test every feature (see TESTING), and do not claim a feature works until you have seen it work.

# GLOBAL RULES
- Leader is Space. Plugins: preservim/nerdtree, ryanoasis/vim-devicons (loaded after nerdtree), joshdick/onedark.vim. vim-plug auto-bootstraps with curl.
- Keep the user's own bits: `g:user42`/`g:mail42` (42 header), the stats logging to ~/.local/state/dev-stats/events.log, and the `dev-stats collect` hook on VimLeavePre.
- Norm: real tabs, width 4, `noexpandtab`, 80 columns (tab = 4), `//` comments forbidden (highlight them).
- Put each feature in its own commented section. Every autocmd goes in an `augroup` with `autocmd!`. Wrap re-sourcing hazards (`if !exists('s:timer')`).
- Keep a static key cheat sheet (`Space ?`) in sync with every key you add.
- Never put project junk in the user's repo (no tags files, no a.out committed, etc.).

# FEATURES AND HOW TO IMPLEMENT THEM

1. VSCode layout
   - `vim .`, `vi .` or `vim`: tree on the LEFT, files open on the RIGHT, tree stays open.
   - Set `g:NERDTreeHijackNetrw=0` and handle startup yourself in a `VimEnter ++nested` function: if argc()==1 and it is a directory, `cd` into it, create an empty buffer, `bwipeout` the directory buffer, `argdelete *`. Then restore the per-directory session, run `NERDTree`, then `wincmd p`.
   - `g:NERDTreeCustomOpenArgs={'file':{'where':'p','reuse':'currenttab','keepopen':1}}`, `g:NERDTreeMouseMode=3` (single click opens), show hidden files but ignore `.git`, `winfixwidth`, no list/signcolumn in the tree, thin `│` separator.
   - Quit Vim when the tree is the last window. Save a session per cwd on VimLeavePre (`sessionoptions=buffers,curdir,folds`; close the tree before mksession).
   - No top tab bar (`showtabline=0`). Switch files with Tab / Shift-Tab (from the tree or terminal, `wincmd p` first), `Space 1..9`, `Space b` (`:ls` then `:buffer `), close with `Space w` (swap in another or empty buffer BEFORE `bdelete`, or the pane closes).
   - Sidebar toggle: Ctrl-b, Ctrl-n, F3. After opening, return the cursor to the editor. `Space e` focuses the tree, `Space f` reveals the file, Ctrl-h/Ctrl-l move between panes.
   - Tree keys: `a` new (end with / for a folder), `r`/F2 rename, `d`/Del delete, `y` copy. Implement them as nmap to NERDTree's menu (`ma`, `mm`, `md`, `mc`). Do NOT map `c` (it delays NERDTree's `cd`). Bind them in a BufEnter autocmd for filetype nerdtree, because NERDTree binds its own keys AFTER FileType and would override yours. Same reason for `<C-j>`.
   - Tree decorations (Vim 9.0.0067+, virtual text via `prop_add` with `text`): `[n:ok]/[n:ko]` from an async `norminette` job, git state `[g:m]`, and age `[u:2d,3h]`. F5 refreshes.

2. Status line (one single status line at the very bottom)
   - `set statusline=%{%StatusLine()%}` (needs Vim 8.2.2854+). Use `g:statusline_winid` to know which window is being drawn. Escape every `%` in dynamic text as `%%`.
   - Content: file name, `[+]`, norm state (green `[norm:ok]` / red), function counter, git branch with `↓↑`, counts (`●` staged, `✚` changed, `?` untracked, `!` conflicts), file state `[clean|staged|modified|untracked]`, last commit hash, message and age, `updated <age>` (file mtime) and `created <age>` (first commit), then `line,col-vcol percent`.
   - Age format: two units at most, M d h m s, for example `1M,5d`, `3h,20m`, `15s`. Use `getbufvar` and `getcurpos(winid)`, not `%l`, so the data can come from another window.
   - Git data comes from `git status --porcelain=v2 --branch` plus `git status --porcelain -- file`, `git log -1 --format=%ct%x09%h%x09%s -- file`, and `git log --diff-filter=A`. Cache per buffer (refresh on BufEnter, FocusGained, BufWritePost, ShellCmdPost, throttle 3s). Redraw with a 1s repeating timer (`redrawstatus!`, skip in command-line mode).
   - Colors: define groups (SLGreen, SLYellow, SLRed, SLBlue, SLPurple, SLDim) inside the function that re-applies highlights after every `:colorscheme`, copying the background from `StatusLine` (handle `reverse`; never pass `#hex` to `ctermbg`). Use colors only in the active window.
   - Narrow windows hide the commit part first, then `created`.
   - Terminal panel rule: when a terminal window is visible, the TERMINAL window's status line shows the editor's info (target = last used editor window, tracked on WinEnter), and editor windows show only a `─` divider. Tree, quickfix and help get a plain status line.
   - Function counter (`.c` only): a function body starts with `{` in column 0 whose previous line ends with `)`, and ends at `}` in column 0 (so struct and enum braces are skipped). Show `ƒ n/5` (red above 5), `[len/25]` for the function under the cursor (yellow above 20, red above 25), and `⚠ L<line> <len>>25` for the first offender. Rescan on BufEnter, TextChanged(I), InsertLeave and redraw on CursorMoved.

3. 42 header and header guard
   - `F1` inserts or updates the standard 42 header. It is auto-inserted for new `.c`/`.h` files AND for empty existing ones (BufReadPost with an empty buffer, because files created from the tree already exist). "Updated:" refreshes on save only when the buffer is modified.
   - New `.h` files get `#ifndef FT_X_H`, `# define FT_X_H`, a blank line and `#endif`. The name is the uppercased file name with non-alphanumerics as `_`. The cursor lands on the blank line. Provide `:HeaderGuard` for existing headers.

4. Norm auto-fix (runs on BufWritePre for .c/.h, and on `Space x`, which also saves and re-runs norminette)
   - Step 1: if `c_formatter_42` is installed, pipe the whole buffer through it. Fall back to step 2 on any failure or empty output.
   - Step 2 built-in fixes: preprocessor indentation by nesting depth (`# define`, `#  define`), 4+ leading spaces to tabs, `if (` `while (` `return (`, `, ` after commas, no space before `;` or `,`, no spaces just inside parentheses. Apply the spacing fixes ONLY to code segments, never inside strings, char literals or comments (split the line with `matchstrpos`). Add a tab between a function's return type and its name (prototypes in a header are aligned together). Align local variable and struct field blocks on tab stops (names start at the next tab stop after the longest type).
   - Existing rules stay: blank line after the include block and after each function, none after `{` or before `}`, one after the local declarations, collapse blank lines, strip trailing whitespace, `void(x);` to `(void)x;`. Optional `g:norm_strip_line_comments`.
   - `g:norm_autofix` toggle (`:NormAutoFixToggle`) and `g:norm_use_c_formatter`.
   - The save fix must NOT run during auto-save (guard with `g:autosaving`).
   - Live lint (no norminette needed), on BufEnter, TextChanged and InsertLeave for .c/.h (skip above 5000 lines):
     * `80` sign plus a red tail past column 80 (`strdisplaywidth` > 80 and `matchadd('\%>80v.\+')`).
     * `>4` sign plus a shaded line when a prototype or definition has more than 4 parameters. Count top-level commas, handle nested parentheses for function pointers, and require a TAB between type and name so `int x = f(a,b,c,d,e);` is not flagged.
     * `!!` sign plus a highlight on the exact word (`matchaddpos`) for forbidden `for`, `do`, `switch`, `case`, `goto` and the ternary `?`. Mask strings, char literals, `//` and `/* */` comments first (a per-byte masker with block-comment state across lines, run only on candidate lines for speed). Skip preprocessor lines.
     * Sign priorities: git 10, norminette `>>` 20, params 16, forbidden 17, long 15. Clear matches per window.
   - Norminette check on `Space n`: parse `Error: CODE (line: n, col: m): msg` (strip ANSI) into quickfix plus signs, and set `b:norm_state`.

5. Build, run, terminal panel, valgrind
   - `Ctrl-e`: save, then look for a `Makefile` upward from the file (stop at $HOME). If found, run `make -C <dir>`, otherwise `gcc -Wall -Wextra -Werror <file> -o a.out`. Run with `systemlist`, load with `cgetexpr`. Count only entries with `valid`, because make adds unparsable lines. Open the quickfix on problems, otherwise `cclose` and echo "Build OK". Return to an editor window first if the cursor is in the tree or quickfix.
   - `F6`: run `./a.out` in a terminal split.
   - Terminal panel on `Ctrl-j` (normal mode, from the tree, and `tnoremap <C-j> <C-\><C-n>:call ...`). Open with `belowright terminal ++close ++rows=12` so it sits under the EDITOR only. Remember its buffer number, hide with `hide` (the shell keeps running), reopen with `belowright 12split | buffer N` plus `feedkeys('i','n')`. Wipe and recreate it if `term_getstatus` is not `running`. `TerminalWinOpen`: `nobuflisted`, no number/sign column, `winfixheight`. `tnoremap <Esc><Esc> <C-\><C-n>`. On QuitPre, if the quit would close the last editor window and the buffer is not modified, `bwipeout!` the terminal (otherwise E947 blocks `:q`).
   - Helper `s:TermRun(cmd)`: open the panel if needed, then `term_sendkeys(buf, 'clear; '.cmd."\<CR>")`.
   - `Space v` / `:Valgrind [args]`: require `valgrind` and an executable `./a.out`, then run `cd <cwd> && valgrind --leak-check=full ./a.out [args]` through `s:TermRun`.

6. Autocomplete popup (no plugin)
   - `complete=.,w,b`, `completeopt=menuone,noinsert,noselect`, `pumheight=10`, `shortmess+=c`.
   - On TextChangedI, when the text before the cursor ends in a word of 3+ characters starting with a letter or `_`, and the popup is not visible, `feedkeys("\<C-n>",'n')`. A flag set on CompleteDone (when `v:completed_item` is non-empty) skips one trigger so it does not reopen after accepting. `:AutoCompleteToggle`.
   - `<Tab>` accepts (selects and accepts the first item if none is highlighted, using `complete_info(['selected'])`), otherwise inserts a real tab. `<S-Tab>` goes back. `<CR>` accepts a highlighted item, closes an unselected popup with `<C-e>` then Enter, otherwise normal Enter (and between `{}` opens an indented block). Auto-close brackets and quotes with skip-over.

7. Auto `#include`
   - A table of about 300 libc, POSIX and readline names mapped to headers (unistd.h, stdlib.h, stdio.h, string.h, strings.h, fcntl.h, sys/wait.h, signal.h, stddef.h, stdint.h, limits.h, ctype.h, math.h, stdbool.h, errno.h, sys/stat.h, sys/types.h, dirent.h, time.h, sys/time.h, pthread.h, stdarg.h, sys/mman.h, termios.h, readline/readline.h, readline/history.h). Build the reverse map at load time.
   - `Space i`: header for `<cword>`. `Space I`: scan the whole file (strings and comments masked); a name counts if it is a call (`name(`), an ALL_CAPS macro, a `_t` type, or in a small identifier list (bool, true, false, errno, stdin, stdout, stderr, va_list, timeval). Skip stddef.h and sys/types.h when another header already provides them.
   - Insert after the last `#include <...>`, else before the first `#include "..."`, else after the 42 header (line 12), else inside the header guard after its `# define` (using `# include` style). Never duplicate, add a blank line after the block, and keep the cursor and view stable.

8. Git from Vim
   - `Space a`: stage the current file, or unstage it if its state is exactly `staged`.
   - `Space c`: save, show `git diff --cached --shortstat`, ask for a message with `input()`, run `git commit -m <shellescape(msg)>`, and show the first output line. If nothing is staged, offer `git add -A` first. Then ask "Push now? [y/N]"; push through `s:TermRun` (so credential prompts work), and refresh the git marks about 4s later. The terminal panel has the focus at that moment, so refresh with `win_execute(editor_winid, 'call s:StatusGit(1)')`.

9. Auto-save
   - Save after 3s idle (restart a timer on TextChanged, TextChangedI, TextChangedP; postpone in command-line or replace mode), on BufLeave, and on FocusLost (`:wall`). Only normal modifiable, named, non-readonly buffers. Set `g:autosaving` around the write so the Norm auto-fix is skipped. `:AutoSaveToggle`. `:q!` must still discard changes (do NOT hook QuitPre or VimLeavePre for saving).

10. Key cheat sheet
   - `Space ?` opens a `popup_create` window with a static grouped list (Files and layout, Sidebar, Build and run, 42 Norm, Git, Editing, Help). Use a custom filter: j/k, arrows, Ctrl-d/u, g/G scroll by setting `firstline` (clamped using `line('$', winid)` and `popup_getpos().core_height`); q, Esc, Enter, `?` close; return 1 for every key.

11. Small things
   - Undo is persistent in ~/.vim/undo; `swapfile` and backups are off. `clipboard=unnamedplus` when available. `autoread` plus checktime. `splitright splitbelow`. `path+=**` and `Ctrl-p` as `:find`. `<` and `>` keep the visual selection. `Esc Esc` and `Space h` clear the search highlight. `Space g` toggles git diff signs (placed from `git diff HEAD -U0`). Quickfix and mappings must never break `Ctrl-h`/`Ctrl-l` pane movement.

# TESTING (mandatory)
- Install: vim-nox (9.1), git, make, gcc, valgrind, `pip install norminette c-formatter-42 pyte --break-system-packages`. Use a sandbox `HOME=/tmp/h`.
- Logic: headless `vim -u vimrc -es -S test.vim file.c`. Write results with `redir!` and check `messages` for errors. Note `execute "normal \<Space>x"` is unreliable in -es (use `call <SNR>1_Func()`), and `input()` cannot be tested there.
- UI and timers: run Vim in a pty (python `pty` plus `pyte`, with a Screen subclass that drops the `private` kwarg of `select_graphic_rendition`) and dump the screen. Use a 120x30+ window. Verify: status line stays at the bottom with the terminal open, the cheat sheet scrolls, `Space v` shows valgrind output, autocomplete accepts with Tab, auto-save writes after 4s idle, the commit/stage/push flow works against a local bare remote (`git init --bare`), and the push result shows in `git log` of the remote.
- Norm: build deliberately messy `.c`/`.h` files (spaces for tabs, `if(`, `return(i)`, `a,b`, ` ;`, `#define` inside a guard, misaligned declarations, strings containing `,` `;` `( )`) and require `norminette` to print `OK!` after the fix, with AND without `c_formatter_42` (set `g:norm_use_c_formatter=0`). Run the fix twice and confirm the body does not change. Header names must match the file (the guard name is checked by norminette).
- Re-run the whole `-es` load check (`silent messages` empty) after EVERY edit.

# DELIVERABLE
The final `vimrc` plus a short summary: the list of keys, what was tested, and anything that could not be tested. Be honest about limits (for example: c_formatter_42 needs `pip3 install --user c-formatter-42`; Makefile projects whose binary is not `a.out` are not supported by F6 and valgrind; line length, function length and function count can only be warned about, not fixed).
