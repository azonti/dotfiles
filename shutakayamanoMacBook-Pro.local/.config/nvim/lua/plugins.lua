return {
  -- colorscheme
  {
    "eldritch-theme/eldritch.nvim",
    branch = "master",
    commit = "c9131a5a11f00a2f428f563a4eb2c4aeb680d963",
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
    branch = "master",
    commit = "71f239af28b7214eebb60d4ea5bd040291fb7e33",
    lazy = true,
    init = function()
      vim.g.DevIconsEnableFoldersOpenClose = 1
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    branch = "master",
    commit = "dfbfaa967a6f7ec50789bead7ef87e336c1fa63c",
    lazy = true,
  },
  {
    "nvim-lua/plenary.nvim",
    branch = "master",
    commit = "74b06c6c75e4eeb3108ec01852001636d85a932b",
    lazy = true,
  },

  -- explorer
  {
    "preservim/nerdtree",
    branch = "master",
    commit = "690d061b591525890f1471c6675bcb5bdc8cdff9",
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
    branch = "master",
    commit = "221ce6b2d999187044529f49da6554a92f740a96",
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
    branch = "main",
    commit = "4916d6592ede8c07973490d9322f187e07dfefac",
    lazy = false,
    build = ":TSUpdate",
    init = function()
      vim.api.nvim_create_augroup("MyVimrcTreesitter", {})
      vim.api.nvim_create_autocmd("FileType", {
        group = "MyVimrcTreesitter",
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)

          if vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf, lang)
            vim.bo[args.buf].indentexpr = "v:lua.require(\"nvim-treesitter\").indentexpr()"
          end
        end,
      })
    end,
    config = function()
      require("nvim-treesitter").install({
        "gitcommit",
        "git_rebase",
        "gitignore",
        "json",
        "json5",
        "xml",
        "yaml",
        "toml",
        "bash",
        "lua",
        "c",
        "cpp",
        "go",
        "javascript",
        "jsx",
        "typescript",
        "tsx",
        "vue",
        "python",
        "ruby",
        "hcl",
        "solidity",
        "elixir",
        "sql",
        "dockerfile",
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    branch = "master",
    commit = "e7ca2c95ba316a8b846d3f3546d407908c5c4ccb",
    lazy = false,
  },
  {
    "nvimtools/none-ls.nvim",
    branch = "main",
    commit = "01f8e62ea11603e59ad9ff7afcfa94fd183f76d6",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.golangci_lint.with({
            timeout = 10000,
          }),
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
    branch = "main",
    commit = "27681d797a26f1b4d6119296df42f5204c88a2dc",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    branch = "main",
    commit = "3e33a6a6c5d379f3d4fae77fae6b53b762a0a30f",
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
    branch = "main",
    commit = "82404b196e73a00b1727a91903beef5ddc319d22",
    lazy = false,
    opts = {},
  },

  -- GitHub Copilot
  {
    "github/copilot.vim",
    branch = "release",
    commit = "a12fd5672110c8aa7e3c8419e28c96943ca179be",
    lazy = false,
  },

  -- snippet engine
  {
    "hrsh7th/vim-vsnip",
    branch = "master",
    commit = "9bcfabea653abdcdac584283b5097c3f8760abaa",
    lazy = false,
    dependencies = {
      "hrsh7th/vim-vsnip-integ",
    },
  },
  {
    "hrsh7th/vim-vsnip-integ",
    branch = "master",
    commit = "c7c93934dece8315db3649bdc6898b76358a8b8d",
    lazy = true,
  },

  -- completion engine
  {
    "hrsh7th/nvim-cmp",
    branch = "main",
    commit = "a1d504892f2bc56c2e79b65c6faded2fd21f3eca",
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
          ["<C-j>"] = cmp.mapping(function(fallback)
            if vim.fn["vsnip#expandable"]() == 1 then
              feedkeys("<Plug>(vsnip-expand)", "")
            else
              fallback()
            end
          end, {"i", "s"}),
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
          { name = "vsnip" },
        },
      })
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    branch = "main",
    commit = "cbc7b02bb99fae35cb42f514762b89b5126651ef",
    lazy = true,
    dependencies = {
      "neovim/nvim-lspconfig",
    },
  },
  {
    "hrsh7th/cmp-buffer",
    branch = "main",
    commit = "b74fab3656eea9de20a9b8116afa3cfc4ec09657",
    lazy = true,
  },
  {
    "hrsh7th/cmp-path",
    branch = "main",
    commit = "c642487086dbd9a93160e1679a1327be111cbc25",
    lazy = true,
  },
  {
    "hrsh7th/cmp-vsnip",
    branch = "main",
    commit = "989a8a73c44e926199bfd05fa7a516d51f2d2752",
    lazy = true,
    dependencies = {
      "hrsh7th/vim-vsnip",
    },
  },

  -- utils
  {
    "tpope/vim-fugitive",
    branch = "master",
    commit = "3b753cf8c6a4dcde6edee8827d464ba9b8c4a6f0",
    lazy = false,
  },

  -- language specific
  {
    "lervag/vimtex",
    branch = "master",
    commit = "fedb7ffc1bebf254cc74e7419c3a5930b6719065",
    ft = "tex",
    init = function()
      vim.g.vimtex_compiler_latexmk_engines = { _ = "-pdfdvi" }
      vim.g.vimtex_view_general_viewer = "qpdfview"
    end,
  },
  {
    "whonore/Coqtail",
    branch = "main",
    commit = "b8f12a068046670645cff583733a32296f4ca261",
    ft = "coq",
  },
  {
    "Julian/lean.nvim",
    branch = "main",
    commit = "6876abd06efb6789081b9f4a3e81503ce07b3c6c",
    ft = "lean",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    opts = {
      mappings = true,
    },
  },
}
