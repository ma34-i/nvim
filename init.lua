-- ======================
-- ショートカット
-- ======================
local opt = vim.opt
local map = vim.keymap.set

-- ======================
-- 基本設定（元のvimrcから移植）
-- ======================
opt.swapfile  = false
opt.backup    = false
opt.undofile  = false

-- インクリメントを10進数に
opt.nrformats = ""

-- シンタックス解析文字数上限
opt.synmaxcol = 200

-- 表示
opt.number = true

-- インデント
opt.smartindent  = true
opt.autoindent   = true
opt.expandtab    = true
opt.tabstop      = 2
opt.shiftwidth   = 2
opt.softtabstop  = 2

-- クリップボード共有（macなら plus）
opt.clipboard = "unnamedplus"

-- ======================
-- 追加設定
-- ======================

-- カラー＆見た目
opt.termguicolors = true      -- 24bit color
opt.cursorline    = true      -- カーソル行をハイライト
opt.signcolumn    = "yes"     -- LSP などの記号が揺れないよう常に表示
opt.scrolloff     = 4         -- 上下に余白を残してスクロール
opt.wrap          = false     -- 行を折り返さない（長い行は横スクロール）

-- ウィンドウ分割の向き
opt.splitbelow = true         -- :split したら下に開く
opt.splitright = true         -- :vsplit したら右に開く

-- 検索周り
opt.ignorecase = true         -- 小文字の検索は大文字小文字を区別しない
opt.smartcase  = true         -- 大文字を含む検索は区別あり
opt.incsearch  = true         -- インクリメンタルサーチ
opt.hlsearch   = true         -- マッチ箇所をハイライト（<Esc> で消したいときはマッピング追加してもOK）

-- マウス
opt.mouse = "a"               -- どのモードでもマウス操作を有効に（不要なら消してOK）

-- コマンドライン補完をポップアップ表示
opt.wildmenu = true

-- タイムアウト（キーマップの待ち時間を短く）
opt.timeoutlen = 500          -- デフォは 1000ms

-- ======================
-- ファイルタイプ設定
-- ======================
-- .md を markdown として認識
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.md",
  command = "set filetype=markdown",
})

-- ======================
-- キーマップ
-- ======================

-- jj で insert モードを抜ける
map("i", "jj", "<ESC>", { silent = true })

-- 検索ハイライトをまとめて消す
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })

-- ウィンドウ移動を Ctrl + h/j/k/l で
map("n", "<C-h>", "<C-w>h", { silent = true })
map("n", "<C-j>", "<C-w>j", { silent = true })
map("n", "<C-k>", "<C-w>k", { silent = true })
map("n", "<C-l>", "<C-w>l", { silent = true })

-- スペースをリーダーキーにする
vim.g.mapleader = " "

-- ======================
-- lazy.nvim のブートストラップ
-- ======================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
opt.rtp:prepend(lazypath)
-- ======================
-- プラグイン設定 
-- ======================
require("lazy").setup({
  { "nvim-lua/plenary.nvim", lazy = true },

  -- 📁 Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep()  end, desc = "Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers()    end, desc = "Buffers" },
      { "<leader>fr", function() require("telescope.builtin").oldfiles()   end, desc = "Recent files" },
    },
  },

  -- 📂 oil.nvim
  {
    "stevearc/oil.nvim",
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
    },
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory (oil)" },
    },
  },
  -- 🎨 Tokyo Night Theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "storm",
        transparent = true,
        terminal_colors = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      })
      vim.cmd([[colorscheme tokyonight]])  -- ← setupの後！ここ重要
      vim.cmd [[ hi Comment guifg=#7c859e ]] --コメントを少し明るく
    end,
  },
})

