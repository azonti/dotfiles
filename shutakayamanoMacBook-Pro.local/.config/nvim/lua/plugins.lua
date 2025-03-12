return {
  -- colorscheme
  {
    "eldritch-theme/eldritch.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("eldritch").setup({
        transparent = true,
      })
      vim.cmd([[colorscheme eldritch]])
    end,
  },

  -- libraries
  {
    "ryanoasis/vim-devicons",
    lazy = true,
    init = function()
      vim.g.DevIconsEnableFoldersOpenClose = 1
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  -- explorer
  {
    "preservim/nerdtree",
    cmd = "NERDTree",
    keys = {
      { "<C-n>", ":NERDTreeToggle<CR>", mode = "n" },
    },
    dependencies = {
      "ryanoasis/vim-devicons",
    },
    init = function()
      local stdin = false

      vim.api.nvim_create_augroup("MyVimrcNERDTree", {})
      vim.api.nvim_create_autocmd("StdinReadPre", {
        group = "MyVimrcNERDTree",
        callback = function()
          stdin = true
        end,
      })
      vim.api.nvim_create_autocmd("VimEnter", {
        group = "MyVimrcNERDTree",
        callback = function()
          if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 and not stdin then
            vim.cmd([[NERDTree ]] .. vim.fn.argv(0))
            vim.cmd([[wincmd p]])
            vim.cmd([[enew]])
            vim.cmd([[cd ]] .. vim.fn.argv(0))
          end
        end,
      })
      vim.api.nvim_create_autocmd({"VimEnter", "BufEnter"}, {
        group = "MyVimrcNERDTree",
        callback = function()
          if vim.api.nvim_get_option_value("filetype", {}) == "nerdtree" then
            vim.cmd([[Fidget suppress true]])
          else
            vim.cmd([[Fidget suppress false]])
          end
        end,
      })
    end,
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        theme = "eldritch",
      },
      extensions = {
        "lazy",
        "nerdtree",
        "fugitive",
      },
    },
  },

  -- Tree-sitter
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = "all",
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local lspconfig = require("lspconfig")

      lspconfig.clangd.setup({})
      lspconfig.gopls.setup({})
      lspconfig.ts_ls.setup({
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = "/opt/homebrew/lib/node_modules/@vue/typescript-plugin",
              languages = {
                "javascript",
                "typescript",
                "vue",
              },
            },
          },
        },
        filetypes = {
          "javascript",
          "typescript",
          "vue",
        },
      })
      lspconfig.volar.setup({})
      lspconfig.pyright.setup({})
      lspconfig.terraformls.setup({})
      lspconfig.solc.setup({})
      lspconfig.elixirls.setup({
        cmd = { "elixir-ls" },
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.golangci_lint,
          require("none-ls.diagnostics.eslint_d"),
          require("none-ls.diagnostics.flake8"),

          require("none-ls.formatting.trim_whitespace").with({
            disabled_filetypes = {
              "diff",
            },
          }),
          require("none-ls.formatting.trim_newlines").with({
            disabled_filetypes = {
              "diff",
            },
          }),
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.goimports,
          require("none-ls.formatting.eslint_d"),
          null_ls.builtins.formatting.prettierd,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.yapf,
          null_ls.builtins.formatting.terraform_fmt,
        },
      })
    end,
  },
  {
    "nvimtools/none-ls-extras.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    lazy = false,
    keys = {
      { "grci", ":Lspsaga incoming_calls<CR>", mode = "n" },
      { "grco", ":Lspsaga outgoing_calls<CR>", mode = "n" },
      { "gra", ":Lspsaga code_action<CR>", mode = "n" },
      { "grd", ":Lspsaga peek_definition<CR>", mode = "n" },
      { "grt", ":Lspsaga peek_type_definition<CR>", mode = "n" },
      { "grr", ":Lspsaga finder<CR>", mode = "n" },
      { "gri", ":Lspsaga finder imp<CR>", mode = "n" },
      { "K", ":Lspsaga hover_doc<CR>", mode = "n" },
      { "gre", ":Lspsaga show_line_diagnostics<CR>", mode = "n" },
      { "grn", ":Lspsaga rename<CR>", mode = "n" },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      finder = {
        methods = {
          tyd = "textDocument/typeDefinition",
        },
        default = "def+tyd+ref+imp",
      },
    },
  },
  {
    "j-hui/fidget.nvim",
    lazy = false,
    opts = {},
  },

  -- GitHub Copilot
  {
    "github/copilot.vim",
    lazy = false,
  },

  -- GitHub Copliot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    lazy = false,
    dependencies = {
      "github/copilot.vim",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      prompts = {
        Explain = {
          prompt = "> /COPILOT_EXPLAIN\n\n選択されたコードについて、段落形式の文章で説明を書いてください。",
        },
        Review = {
          prompt = "> /COPILOT_REVIEW\n\n選択されたコードをレビューしてください。",
        },
        Fix = {
          prompt = "> /COPILOT_GENERATE\n\nこのコードに問題があります。バグを修正した状態のコードに書き直してください。",
        },
        Optimize = {
          prompt = "> /COPILOT_GENERATE\n\n選択されたコードのパフォーマンスと可読性を向上させるために最適化してください。",
        },
        Docs = {
          prompt = "> /COPILOT_GENERATE\n\n選択されたコードにドキュメント用のコメントを追加してください。",
        },
        Tests = {
          prompt = "> /COPILOT_GENERATE\n\n私のコードに対するテストを生成してください。",
        },
        Commit = {
          prompt = "> #git:staged\n\ncommitizenの規約に従い、変更のためのコミットメッセージを書いてください。タイトルは最大50文字、メッセージは72文字ごとに改行してください。全体をgitcommit言語のコードブロックで囲んでください。",
        },
      },
      mappings = {
        complete = {
          insert = "",
        },
      },
    },
  },

  -- snippet engine
  {
    "hrsh7th/vim-vsnip",
    keys = {
      { "<C-j>", function() return vim.fn["vsnip#expandable"]() and "<Plug>(vsnip-expand)" or "<C-j>" end, mode = "i" },
      { "<C-j>", function() return vim.fn["vsnip#expandable"]() and "<Plug>(vsnip-expand)" or "<C-j>" end, mode = "s" },
    },
    dependencies = {
      "hrsh7th/vim-vsnip-integ",
    },
  },
  {
    "hrsh7th/vim-vsnip-integ",
    lazy = true,
  },

  -- completion engine
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
    },
    config = function()
      local cmp = require("cmp")

      local has_space_before = function()
        local line, column = unpack(vim.api.nvim_win_get_cursor(0))
        return column == 0 or vim.api.nvim_buf_get_lines(0, line-1, line, true)[1]:sub(column, column):match("%s") ~= nil
      end

      local feedkeys = function(keys, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), mode, false)
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if has_space_before() then
              fallback()
            elseif cmp.visible() then
              cmp.select_next_item()
            elseif vim.fn["vsnip#jumpable"](1) == 1 then
              feedkeys("<Plug>(vsnip-jump-next)", "")
            else
              fallback()
            end
          end, {"i", "s"}),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
              feedkeys("<Plug>(vsnip-jump-prev)", "")
            else
              fallback()
            end
          end, {"i", "s"}),
          ["<C-e>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.close()
            else
              fallback()
            end
          end, {"i", "s"}),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = true,
    dependencies = {
      "neovim/nvim-lspconfig",
    },
  },
  {
    "hrsh7th/cmp-buffer",
    lazy = true,
  },
  {
    "hrsh7th/cmp-path",
    lazy = true,
  },
  {
    "hrsh7th/cmp-vsnip",
    lazy = true,
    dependencies = {
      "hrsh7th/vim-vsnip",
    },
  },

  -- utils
  {
    "tpope/vim-fugitive",
    lazy = false,
  },

  -- language specific
  {
    "lervag/vimtex",
    ft = "tex",
    init = function()
      vim.g.vimtex_compiler_latexmk_engines = { _ = "-pdfdvi" }
      vim.g.vimtex_view_general_viewer = "qpdfview"
    end,
  },
  {
    "whonore/Coqtail",
    ft = "coq",
  },
  {
    'Julian/lean.nvim',
    ft = "lean",
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    opts = {
      mappings = true,
    },
  },
}
