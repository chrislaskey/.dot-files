--[[ NOTES

  ## Setup: System packages

    $ brew install neovim
    $ brew install ripgrep

  ## Fonts

    $ git clone https://github.com/Karmenzind/monaco-nerd-fonts
    $ cp -r monaco-nerd-fonts/fonts/ /usr/share/fonts/monaco-nerd-fonts

  ## Plugins

  Check health with `:checkhealth <plugin-name>`, for example:

    :checkhealth telescope

  ## Color schemes

  :colorscheme nordic
  :colorscheme sonokai

--]]

-- Basic settings
vim.o.timeoutlen = 250 -- Set timeout length to be quicker than the default 1000, Great for leader based commands
vim.opt.errorbells = false -- Turn off beeping. On buffer enter make the visual bell zero time, so it doesn't blink.
vim.o.visualbell = true

vim.o.splitbelow = true -- New window goes below
vim.o.splitright = true -- New windows goes right
vim.o.winminheight = 0 -- Allow splits to be reduced to a single line.

vim.o.cmdheight = 1 -- Set command height
-- vim.o.cursorline = true --- Highlight current line
vim.o.laststatus = 2 -- 0 is always off, 1 is if there is more than 1 window, 2 is always on.
vim.opt.startofline = false -- Don't reset cursor to start of line when moving around.
vim.o.number = true
vim.o.report = 0 -- Always report number of lines changed for a command
vim.o.ruler = true -- Displays the linenumber, column number in the status line (default is far right)
vim.wo.relativenumber = false -- Use relative line numbers
vim.o.showcmd = true
vim.o.scrolloff = 4 -- Minimum number of lines to show around the cursor while scrolling
vim.o.sidescrolloff = 4 -- Minimum number of horizontal characters while scrolling horizontally
vim.o.undofile = true -- Persisted undo across vim sessions
vim.o.signcolumn = "number" -- merge signcolumn and number column into one
vim.o.wrap = false -- Disable line wrap by default

--- Default text formatting options (default is tcq)
--vim.o.formatoptions= -- See :h fo-table; for more information on each option
--vim.o.formatoptions+=c -- Format comments
--vim.o.formatoptions+=r -- Continue comments by default
--vim.o.formatoptions+=o -- Make comment when using o or O from comment line
--vim.o.formatoptions+=q -- Format comments with gq
--vim.o.formatoptions+=n -- Recognize numbered lists
--vim.o.formatoptions+=2 -- Use indent from 2nd line of a paragraph
--vim.o.formatoptions+=l -- Don't break lines that are already long
--vim.o.formatoptions+=1 -- Break before 1-letter words

vim.o.backspace = "start,indent,eol" -- Allow backspacing over everything in insert mode
  -- vim.o.iskeyword+=_,$,@,%,#
vim.o.virtualedit = onemore -- cursor can go one char past end of line
vim.opt.joinspaces = false -- Insert a single space after punctuation with a join command.
vim.o.showmatch = true
vim.o.textwidth = 0

vim.o.expandtab = true
vim.o.smartindent = false
vim.o.cindent = true
vim.o.smarttab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.shiftround = true
 --vim.o.preserveindent = true
 --vim.o.copyindent = true
 --vim.o.autoindent = true

vim.api.nvim_command("filetype plugin indent on")
vim.api.nvim_command("set cinkeys-=0#")
vim.api.nvim_command("set indentkeys-=0#")
vim.api.nvim_command("autocmd FileType * set cindent")

--- Search
vim.o.gdefault = true -- By default add g flag to search/replace. Add g to toggle.
vim.o.hlsearch = true -- Highlights search results.
vim.o.ignorecase = true -- Ignores case in searches by default
vim.o.incsearch = true -- Searches as you type
vim.o.smartcase = true -- Turns on case sensitivity if search contains a capital letter

-- Key bindings

--- General
vim.keymap.set("n", "K", "k", { noremap = true }) -- No man page lookup
vim.keymap.set("n", "zm", "zz", { noremap = true }) -- Rebind zz (move current line to middle) to zm.

vim.keymap.set("n", "<Tab>", "<ESC>", { noremap = true }) -- Use tab key as esc in normal mode

vim.keymap.set("n", "<CR>", "o<ESC>", { noremap = true }) -- Insert spaces with enter in normal mode
vim.keymap.set("n", "O", "O<ESC>", { noremap = true }) -- Insert spaces with enter in normal mode
vim.keymap.set("n", "Y", "y$", { noremap = true }) -- Make Y consistent with C and D

vim.keymap.set("n", "k", "gk", { noremap = true }) -- Navigate by visual lines
vim.keymap.set("n", "j", "gj", { noremap = true }) -- Navigate by visual lines

vim.keymap.set("i", "<Down>", "<C-o>gj", { noremap = true }) -- Make arrow keys work as expected in wrapped lines in interactive mode
vim.keymap.set("i", "<uP>", "<C-o>gk", { noremap = true }) -- Make arrow keys work as expected in wrapped lines in interactive mode

vim.keymap.set("v", "u", "", { noremap = true }) -- Make case toggling in visual mode harder to accidentally hit
vim.keymap.set("v", "U", "", { noremap = true }) -- Make case toggling in visual mode harder to accidentally hit

vim.keymap.set("n", "gp", "`[v`]]", { noremap = true }) -- Select pasted content

--- Leader
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false }) -- Allow space to be used as leader key
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true }) -- Write
vim.keymap.set("v", "<leader>w", ":w<CR>", { noremap = true }) -- Write
vim.keymap.set("n", "<leader>a", "ggVG", { noremap = true }) -- Select all
vim.keymap.set("v", "<leader>a", "ggVG", { noremap = true }) -- Select all
vim.keymap.set("n", "<leader>pa", ":set invpaste paste?<CR>", { noremap = true }) -- Fix cut and paste in command line vim on Mac OS X. See: http://superuser.com/a/134751 and http://stackoverflow.com/a/2555659/657661
vim.keymap.set("n", "<leader>[", ":noh<Return><Esc>", { noremap = true }) -- Remove search highlighting
vim.keymap.set("n", "<leader>pf", "p'[v']=", { noremap = true }) -- Smart paste, includes formatting like indentation
vim.keymap.set("n", "<leader>Pf", "P'[v']=", { noremap = true }) -- Smart paste, includes formatting like indentation
vim.keymap.set("n", "<leader>cd", ":lcd %:p:h<cr>:pwd<cr>", { noremap = true }) -- CD to directory of current file

--- Buffers
vim.keymap.set("n", "<leader>b", ":b#<CR>", { noremap = true })
vim.keymap.set("n", "<leader>bp", ":bp<CR>", { noremap = true })
vim.keymap.set("n", "<leader>bn", ":bn<CR>", { noremap = true })
vim.keymap.set("n", "<leader>b1", ":b1<CR>", { noremap = true })
vim.keymap.set("n", "<leader>b2", ":b2<CR>", { noremap = true })
vim.keymap.set("n", "<leader>b3", ":b3<CR>", { noremap = true })
vim.keymap.set("n", "<leader>b4", ":b4<CR>", { noremap = true })
vim.keymap.set("n", "<leader>b5", ":b5<CR>", { noremap = true })
vim.keymap.set("n", "<leader>b6", ":b6<CR>", { noremap = true })
vim.keymap.set("n", "<leader>b7", ":b7<CR>", { noremap = true })
vim.keymap.set("n", "<leader>b8", ":b8<CR>", { noremap = true })
vim.keymap.set("n", "<leader>b9", ":b9<CR>", { noremap = true })
vim.keymap.set("n", "<leader>1", ":b1<CR>", { noremap = true })
vim.keymap.set("n", "<leader>2", ":b2<CR>", { noremap = true })
vim.keymap.set("n", "<leader>3", ":b3<CR>", { noremap = true })
vim.keymap.set("n", "<leader>4", ":b4<CR>", { noremap = true })
vim.keymap.set("n", "<leader>5", ":b5<CR>", { noremap = true })
vim.keymap.set("n", "<leader>6", ":b6<CR>", { noremap = true })
vim.keymap.set("n", "<leader>7", ":b7<CR>", { noremap = true })
vim.keymap.set("n", "<leader>8", ":b8<CR>", { noremap = true })
vim.keymap.set("n", "<leader>9", ":b9<CR>", { noremap = true })


--- Windows
-- Better split switching (Ctrl-j, Ctrl-k, Ctrl-h, Ctrl-l)
vim.keymap.set("n", "<C-j>", "<C-W>j", {})
vim.keymap.set("n", "<C-k>", "<C-W>k", {})
vim.keymap.set("n", "<C-H>", "<C-W>h", {})
vim.keymap.set("n", "<C-L>", "<C-W>l", {})

--- Indentation
--- Keep visual selection after changing indentation level
vim.keymap.set("v", "<", "<gv", {})
vim.keymap.set("v", ">", ">gv", {})

-- Packages: package manager installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- packages
require("lazy").setup({
  -- Fonts
  "nvim-tree/nvim-web-devicons",
  -- Color schemes
  "sainnhe/sonokai",
  "nyoom-engineering/oxocarbon.nvim",
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require 'nordic'.load()
    end
  },
  -- {
  --   "navarasu/onedark.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require 'onedark'.setup { style = 'darker' }
  --     require 'onedark'.load()
  --   end
  -- },
  -- Plugins
  "nvim-lualine/lualine.nvim",
  "farmergreg/vim-lastplace",
  "gbprod/substitute.nvim",
  "sindrets/diffview.nvim",
	"cshuaimin/ssr.nvim",
  -- {
  --   "folke/flash.nvim",
  --   event = "VeryLazy",
  --   opts = {},
  --   keys = {
  --     { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  --     { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  --     { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
  --     { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  --     { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  --   },
  -- },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
  },
  {
    "numToStr/Comment.nvim",
    lazy = false,
  },
  {
    "echasnovski/mini.nvim",
    version = false,
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- {"nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0"}
    },
    config = function()
      -- require("telescope").load_extension("live_grep_args")
    end
  },
  {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    config = function()
      require("telescope").load_extension("smart_open")
    end,
    dependencies = {
      "kkharji/sqlite.lua"
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim"
    }
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
  },
  {
    "ThePrimeagen/harpoon",
    -- branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim"
    }
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons"
  },
  -- {
  --   "BourbonBidet/Barpoon",
  --   dependencies = {
  --     "ThePrimeagen/harpoon",
  --     "akinsho/bufferline.nvim"
  --   },
  --   opts = {}, -- Config here
  -- },
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		dependencies = { "rafamadriz/friendly-snippets" },
		build = "make install_jsregexp",
	},
	{"saadparwaiz1/cmp_luasnip"},
  -- LSP and autocomplete
  {"VonHeikemen/lsp-zero.nvim", branch = "v3.x"},
  {"neovim/nvim-lspconfig"},
  {"hrsh7th/cmp-buffer"},
  {"hrsh7th/cmp-cmdline"},
  {"hrsh7th/cmp-nvim-lsp"},
  {"hrsh7th/cmp-path"},
  {"hrsh7th/cmp-vsnip"},
  {"hrsh7th/nvim-cmp"},
  {"hrsh7th/vim-vsnip"},
  {"nvim-treesitter/nvim-treesitter"},
  {"smjonas/inc-rename.nvim", opts = {}},
  -- LLMs
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   version = false, -- Never set this value to "*"! Never!
  --   opts = {
  --     provider = "claude",
  --     claude = {
  --       endpoint = "https://api.anthropic.com",
  --       model = "claude-3-5-sonnet-20241022",
  --       timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
  --       temperature = 0,
  --       max_tokens = 4096,
  --     },
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = "make",
  --   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     "echasnovski/mini.pick", -- for file_selector provider mini.pick
  --     "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
  --     "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
  --     "ibhagwan/fzf-lua", -- for file_selector provider fzf
  --     "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     --"zbirenbaum/copilot.lua", -- for providers='copilot'
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       'MeanderingProgrammer/render-markdown.nvim',
  --       opts = {
  --         file_types = { "markdown", "Avante" },
  --       },
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  -- }
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup({})
  --   end,
  -- },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   config = function ()
  --     require("copilot_cmp").setup()
  --   end
  -- },
  -- Disabled
  -- "folke/which-key.nvim",
  -- "rgroli/other.nvim",
  -- "chentoast/marks.nvim",
})

-- Colorschemes
vim.opt.background = "dark"
--vim.cmd("colorscheme onedark")
vim.cmd("colorscheme nordic")

-- Packages: `telescope`
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", ":Telescope harpoon marks<CR>", {})
vim.keymap.set("n", "<leader>fm", builtin.marks, {})
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, {})
-- vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
-- vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", {})
-- Use the `live_grep_args` plugin to enable filtering by directory or filetype. Examples:
--  'hello' -g '*.ex'
--    To search only inside `.ex` files
--  'hello' -telixir
--    To search only inside elixir files (uses ripgrep's ability to detect file types)

require("telescope").setup({
  pickers = {
    live_grep = {
      mappings = {
        -- Refine grep results
        i = { ["<C-d>"] = require("telescope.actions").to_fuzzy_refine },
      },
    },
  }
})

-- Packages: `mini-statusline`
require("lualine").setup({
  sections = {
    lualine_c = {
      {
        'filename',
        shorting_target = 40, -- How many directory path characters to display before shortening
        path = 1,
      }
    }
  }
})

-- Packages: `neo-tree`
require("neo-tree").setup({
  window = {
    position = "right",
    width = 46,
  },
  mappings = {
    ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
    ["?"] = "show_help",
  },
  filesystem = {
    filtered_items = {
      show_hidden_count = false
    },
    follow_current_file = {
      --enabled = true,
      leave_dirs_open = true
    },
    window = {
      mappings = {
        ["/"] = "noop"
      }
    }
  }
})

vim.keymap.set("n", "nt", ":Neotree toggle reveal<CR>", { noremap = true })
vim.keymap.set("n", "ntf", ":Neotree reveal<CR>", { noremap = true })

-- Packages: `nvim-surround`
--- Tips:
--   `csqb` to automatically find the closest single, double, or backtick quotes and change it
--   `ysw` to wrap current word in quote
--   `ys$` to wrap current cursor to end of line in quote
--   `dst` to delete the surrounding html tag
require("nvim-surround").setup()

-- Packages: `flash`
-- require("flash").setup({
--   modes = {
--     -- options used when flash is activated through
--     -- `f`, `F`, `t`, `T`, `;` and `,` motions
--     char = {
--       highlight = { backdrop = false },
--     },
--   },
-- })

-- Packages: `Comment`
require("Comment").setup({
  toggler = {
    -- Line-comment keymap
    line = '\\\\\\',
    ---Block-comment toggle keymap
    block = 'gbc',
  },
  opleader = {
    -- Line-comment keymap
    line = '\\\\',
    ---Block-comment keymap
    block = 'gb',
  }
})

local comment_file_types = require('Comment.ft')

-- Chainable with more `.set()` calls.
-- Value sets both line and block commentstring
comment_file_types
  .set('heex', {'<%#%s%>', '<%!--%s--%>'})

-- Packages: `diffview`
require("diffview").setup({})

vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { noremap = true })
vim.keymap.set("n", "<leader>gq", ":DiffviewClose<CR>", { noremap = true })

-- Packages: Structural search and replace (SSR) (https://github.com/cshuaimin/ssr.nvim)
require("ssr").setup({
	border = "rounded",
	min_width = 50,
	min_height = 5,
	max_width = 120,
	max_height = 25,
	adjust_window = true,
	keymaps = {
		close = "q",
		next_match = "n",
		prev_match = "N",
		replace_confirm = "<cr>",
		replace_all = "<leader><cr>",
	},
})

vim.keymap.set({ "n", "x" }, "<leader>sr", function() require("ssr").open() end)

-- Packages: `harpoon`
local harpoon = require("harpoon")

harpoon.setup({})

-- vim.keymap.set("n", "ha", function() harpoon:list():add() end, { noremap = true })
-- vim.keymap.set("n", "hd", function() harpoon.list():remove() end, { noremap = true })
-- vim.keymap.set("n", "hcc", function() harpoon.list():clear() end, { noremap = true })
-- vim.keymap.set("n", "hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { noremap = true })
-- vim.keymap.set("n", "hn", function() harpoon.list():next() end, { noremap = true })
-- vim.keymap.set("n", "hp", function() harpoon.list():prev() end, { noremap = true })
-- vim.keymap.set("n", "h1", function() harpoon:list():select(1) end, { noremap = true })
-- vim.keymap.set("n", "h2", function() harpoon.list():select(2) end, { noremap = true })
-- vim.keymap.set("n", "h3", function() harpoon.list():select(3) end, { noremap = true })
-- vim.keymap.set("n", "h4", function() harpoon.list():select(4) end, { noremap = true })
-- vim.keymap.set("n", "h5", function() harpoon.list():select(5) end, { noremap = true })
-- vim.keymap.set("n", "h6", function() harpoon.list():select(6) end, { noremap = true })
-- vim.keymap.set("n", "h7", function() harpoon.list():select(7) end, { noremap = true })
-- vim.keymap.set("n", "h8", function() harpoon.list():select(8) end, { noremap = true })
-- vim.keymap.set("n", "h9", function() harpoon.list():select(9) end, { noremap = true })

vim.keymap.set("n", "ha", ":lua require(\"harpoon.mark\").add_file()<CR>", { noremap = true })
vim.keymap.set("n", "hm", ":lua require(\"harpoon.mark\").add_file()<CR>", { noremap = true })
vim.keymap.set("n", "hd", ":lua require(\"harpoon.mark\").rm_file()<CR>", { noremap = true })
vim.keymap.set("n", "hcc", ":lua require(\"harpoon.mark\").clear_all()<CR>", { noremap = true })
vim.keymap.set("n", "hl", ":lua require(\"harpoon.ui\").toggle_quick_menu()<CR>", { noremap = true })
vim.keymap.set("n", "hn", ":lua require(\"harpoon.ui\").nav_next()<CR>", { noremap = true })
vim.keymap.set("n", "hp", ":lua require(\"harpoon.ui\").nav_prev()<CR>", { noremap = true })
vim.keymap.set("n", "h1", ":lua require(\"harpoon.ui\").nav_file(1)<CR>", { noremap = true })
vim.keymap.set("n", "h2", ":lua require(\"harpoon.ui\").nav_file(2)<CR>", { noremap = true })
vim.keymap.set("n", "h3", ":lua require(\"harpoon.ui\").nav_file(3)<CR>", { noremap = true })
vim.keymap.set("n", "h4", ":lua require(\"harpoon.ui\").nav_file(4)<CR>", { noremap = true })
vim.keymap.set("n", "h5", ":lua require(\"harpoon.ui\").nav_file(5)<CR>", { noremap = true })
vim.keymap.set("n", "h6", ":lua require(\"harpoon.ui\").nav_file(6)<CR>", { noremap = true })
vim.keymap.set("n", "h7", ":lua require(\"harpoon.ui\").nav_file(7)<CR>", { noremap = true })
vim.keymap.set("n", "h8", ":lua require(\"harpoon.ui\").nav_file(8)<CR>", { noremap = true })
vim.keymap.set("n", "h9", ":lua require(\"harpoon.ui\").nav_file(9)<CR>", { noremap = true })

-- Context specific bindings
vim.api.nvim_set_keymap("n", "<leader>lt", "<cmd>:Other test<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ls", "<cmd>:Other scss<CR>", { noremap = true, silent = true })

-- Packages: `nvim-autopairs`
require("nvim-autopairs").setup({})

-- Packages: `substitute`
--- Tips:
--   `siw` substitute in word. Takes current yank entry and keeps it.
--   `st,` substitute from current cursor to next comma with current yank entry
local substitute = require("substitute")

substitute.setup({})

vim.keymap.set("n", "s", substitute.operator, { noremap = true })
vim.keymap.set("n", "ss", substitute.line, { noremap = true })
vim.keymap.set("n", "S", substitute.eol, { noremap = true })
vim.keymap.set("x", "s", substitute.visual, { noremap = true })

-- Packages: `bufferline`
require("bufferline").setup({
  options = {
    numbers = "buffer_id",
    tab_size = 16,
    show_buffer_close_icons = false,
  }
})

-- Packages: `lua-snip`
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load({paths = "~/.config/nvim/snippets"})
require("luasnip.loaders.from_vscode").lazy_load()

-- Packages: `marks`
-- Tips:
--   `ma` create mark "a
--   `dm-` delete mark on current line
--   `dm<space>` delete all marks in current buffer
--   `m[` and `m]` to go forward/back between mark
-- require("marks").setup({})

-- Packages: `zbirenbaum/copilot.lua`
-- local copilot = require("copilot")
--
-- copilot.setup({
--   panel = {
--     enabled = false,
--     auto_refresh = false,
--     keymap = {
--       jump_prev = "[[",
--       jump_next = "]]",
--       accept = "<CR>",
--       refresh = "gr",
--       open = "<M-CR>"
--     },
--     layout = {
--       position = "right", -- | top | left | right
--       ratio = 0.4
--     },
--   },
--   suggestion = {
--     enabled = false,
--     auto_trigger = true,
--     hide_during_completion = true,
--     debounce = 75,
--     keymap = {
--       accept = "<M-l>",
--       accept_word = false,
--       accept_line = false,
--       next = "<M-]>",
--       prev = "<M-[>",
--       dismiss = "<C-]>",
--     },
--   },
--   filetypes = {
--     yaml = false,
--     markdown = false,
--     help = false,
--     gitcommit = false,
--     gitrebase = false,
--     hgcommit = false,
--     svn = false,
--     cvs = false,
--     ["."] = false,
--   },
--   copilot_node_command = 'node', -- Node.js version must be > 18.x
--   server_opts_overrides = {},
-- })

-- Packages: Dexter (LSP)
vim.lsp.config('dexter', {
  cmd = { 'dexter', 'lsp' },
  root_markers = { '.dexter/dexter.db', '.dexter.db', '.git', 'mix.exs' },
  filetypes = { 'elixir', 'eelixir', 'heex' },
  init_options = {
    followDelegates = true,  -- jump through defdelegate to the target function
    -- stdlibPath = "",      -- override Elixir stdlib path (auto-detected)
    -- debug = false,        -- verbose logging to stderr (view with :LspLog)
  },
})

vim.lsp.enable 'dexter'

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<C-[>", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "K", function () vim.lsp.buf.hover() end, { desc = "Hover" })

-- Packages: LSP
local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lso-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})

  -- local opts = {buffer = bufnr, remap = false}
  --
  -- vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  -- vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  -- vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  -- vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  -- vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  -- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  -- vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cd', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
end)

vim.keymap.set("n", "<leader>f", ":LspZeroFormat timeout=5000<CR>", { noremap = true }) -- Format file using LSP

-- NOTE: downloading Elixir LS
-- https://github.com/elixir-lsp/elixir-ls/releases/download/v0.14.6/elixir-ls.zip

-- require('lspconfig').elixirls.setup {
--    cmd = { "/Users/chrislaskey/code/elixir-ls/language_server.sh" },
--    on_attach = on_attach
-- }

-- vim.lsp.config("elixirls.setup", {
--   cmd = { "/Users/chrislaskey/code/elixir-ls/language_server.sh" },
--   on_attach = on_attach
-- })

-- NOTE: autocomplete integration with luasnip
-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_compare = require("cmp.config.compare")

cmp.setup({
  view = {
		docs = {
			auto_open = false,
		},
	},
  sources = {
    {name = "copilot"},
    {name = "path"},
    {name = "luasnip"},
    {name = "nvim_lsp"},
    {name = "nvim_lua"},
    {name = "elixir-ls"},
  },
  formatting = lsp_zero.cmp_format(),
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),

		--Integrate with Luasnip
		-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
		--
		-- Disabled these simpler versions to integrate with luasnip.
		--
    --   ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    --   ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    --   ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		--
		-- Also changes prev/select/next keybindings from p/y/n to j/l/k

		["<C-l>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
				cmp.confirm({ select = true })
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

		["<C-k>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item(cmp_select)
      elseif luasnip.jumpable(1) then
        luasnip.jump(1)
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<C-j>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(cmp_select)
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
})

--To use snippets in visual mode
-- First select the text. Then hit the <C-l> key.
-- The selected text will temporarily disappear.
-- Type the snippet shortcut (like `i` to inspect value)
-- Select the snippet value (in this case, using the <C-l> key again)
luasnip.config.setup({store_selection_keys = "<C-l>"})

require 'nvim-treesitter.configs'.setup {
  ensure_installed = all,
  sync_install = false,
  ignore_install = { },
  highlight = {
    enable = true,
    disable = { },
  },
}

-- Keybindings for multi-ide setup

vim.keymap.set("n", "<leader>oe", ":!open -a /Applications/Cursor.app %<CR><CR>e!%", { desc = '[O]pen [E]xternal editor then reopen file'})
vim.keymap.set("n", "<leader>e", ":e!%<CR>", { desc = 'R[e]open file'})

vim.keymap.set("n", "<leader>i",
  function ()
    -- Get cursor position (0-based row, 0-based col)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    -- Use 0-based index for API calls, 1-based for vimscript functions/cursor setting
    local current_lnum_0based = cursor_pos[1] - 1
    local current_lnum_1based = current_lnum_0based + 1

    -- Get current line content
    -- API uses 0-based, end index is exclusive
    local line_content = vim.api.nvim_buf_get_lines(0, current_lnum_0based, current_lnum_0based + 1, false)[1] or ""

    -- Check for Elixir pipe '|>' literally (disable pattern matching)
    if string.find(line_content, "|>", 1, true) then
      -- Case 0: Elixir pipeline detected
      -- Get indent of current line (vim.fn.indent needs 1-based lnum)
      local indent_level = vim.fn.indent(current_lnum_1based)
      local indent_str = string.rep(' ', indent_level)
      local new_line_text = indent_str .. "|> dbg()"

      -- Insert the new line *after* the current one
      -- API uses 0-based indices. Insert before line current_lnum_0based + 1
      vim.api.nvim_buf_set_lines(0, current_lnum_0based + 1, current_lnum_0based + 1, false, {new_line_text})

      -- Move cursor to the start of the inserted dbg line's text content
      -- New line is at index current_lnum_0based + 1 (0-based)
      -- Target row is current_lnum_1based + 1 (1-based)
      -- Target col is indent_level (0-based)
      vim.api.nvim_win_set_cursor(0, {current_lnum_1based + 1, indent_level})
      -- Stay in normal mode

    else
      -- Original logic if no pipe is found on the line
      -- Check if the line contains any character NOT in the ignored set
      local has_meaningful_content = string.match(line_content, "[^ \t|>\n\r]")

      if not has_meaningful_content then
        -- Case 1: Line is effectively empty (only ignored chars)
        local yank_value = vim.fn.getreg('"')
        local text_to_insert

        -- Check if yank is non-empty and single-line
        if yank_value ~= '' and not string.find(yank_value, "\n") then
          text_to_insert = 'dbg(' .. yank_value .. ')'
        else
          text_to_insert = 'dbg()'
        end

        -- Move cursor to end of the line before inserting (API needs 0-based col)
        -- #line_content gives byte length, which is the 0-based index *after* the last char
        vim.api.nvim_win_set_cursor(0, {current_lnum_1based, #line_content}) -- 1-based row

        -- Insert text at the end and enter insert mode
        vim.api.nvim_put({text_to_insert}, 'c', true, true)

      else
        -- Case 2: Line has meaningful content (and no pipe)
        -- Get original indentation
        local indent_level = vim.fn.indent(current_lnum_1based)
        local indent_str = string.rep(' ', indent_level)
        -- Trim leading/trailing whitespace from the original content
        local trimmed_content = vim.trim(line_content)
        -- Construct the new line content with indentation
        local new_line_content = indent_str .. 'dbg(' .. trimmed_content .. ')'

        -- Replace the entire line (API uses 0-based indices)
        vim.api.nvim_buf_set_lines(0, current_lnum_0based, current_lnum_0based + 1, false, {new_line_content})

        -- Move cursor inside the parentheses, just before the final ')'
        -- Calculate 0-based target column, accounting for indent
        local target_col = indent_level + #('dbg(' .. trimmed_content)

        vim.api.nvim_win_set_cursor(0, {current_lnum_1based, target_col}) -- 1-based row
        -- Stay in normal mode
      end
    end
  end,
  { desc = '[i]nsert dbg() intelligently (Elixir pipe aware)' } -- Description remains the same
)

-- vim.keymap.set("n", "<leader>ox",
--   function()
--     local r, c = unpack(vim.api.nvim_win_get_cursor(0))
--     vim.cmd('!open -a /Applications/Cursor.app ' .. vim.fn.expand('%') .. ':' .. r .. ':' .. c)
--     --vim.cmd('!open -a /Applications/Cursor.app . && open -a /Applications/Cursor.app --goto "' .. vim.fn.expand('%') .. ':' .. r .. ':' .. c .. '"')
--     --vim.cmd('!open -a /Applications/Cursor.app ' .. vim.fn.expand('%') .. ' && open -a /Applications/Cursor.app -g "' .. vim.fn.expand('%') .. ':' .. r .. ':' .. c .. '"')
--   end,
--   { desc = '[O]pen E[x]ternal editor' }
-- )
--

-- Inc Rename (LSP aware renaming)

vim.keymap.set("n", "grn", function()
	return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "LSP rename (incremental)" })
