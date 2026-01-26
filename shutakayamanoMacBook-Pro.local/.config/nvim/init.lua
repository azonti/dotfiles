-- init
vim.api.nvim_create_augroup("MyVimrc", {})


-- providers
vim.g.python3_host_prog = vim.fn.system("pushd ~ > /dev/null && (asdf which python3 || which python3) 2>/dev/null && popd > /dev/null"):gsub("\n$", "")


-- plugins
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazy_path) then
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazy_path })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.runtimepath:prepend(lazy_path)


-- edit
vim.g.mapleader = "\\"
vim.g.maplocalleader = "_"

vim.opt.updatetime = 300

vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.undofile = true

vim.opt.autowrite = true

vim.opt.confirm = true

vim.opt.shiftwidth = 2

vim.opt.expandtab = true

vim.opt.mouse = "a"


-- view
vim.opt.list = true
vim.opt.listchars = {
  tab = "»-",
  trail = "￮",
  eol = "￩",
  extends = "»",
  precedes = "«",
  nbsp = "￭",
}

vim.api.nvim_create_autocmd({"VimEnter", "WinEnter"}, {
  group = "MyVimrc",
  callback = function()
    vim.cmd([[match UnicodeSpaces /\%u180E\|\%u2000\|\%u2001\|\%u2002\|\%u2003\|\%u2004\|\%u2005\|\%u2006\|\%u2007\|\%u2008\|\%u2009\|\%u200A\|\%u2028\|\%u2029\|\%u202F\|\%u205F\|\%u3000/]])
  end,
})
vim.api.nvim_create_autocmd("ColorScheme", {
  group = "MyVimrc",
  callback = function()
    vim.cmd([[highlight UnicodeSpaces cterm=underline ctermfg=0 ctermbg=1 gui=underline guifg=#000000 guibg=#800000]])
  end,
})

vim.opt.number = true

vim.opt.signcolumn = "yes"

vim.opt.showmode = false

vim.opt.cursorline = true

vim.opt.showmatch = true

vim.opt.wildmode = "list:longest"

vim.opt.tabstop = 2

vim.opt.conceallevel = 2

vim.g.tex_flavor = "latex"
vim.g.tex_conceal = "abdmg"


-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true


-- LSP
vim.lsp.enable('clangd')
vim.lsp.enable('gopls')
vim.lsp.config('ts_ls', {
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
vim.lsp.enable('ts_ls')
vim.lsp.enable('vue_ls')
vim.lsp.enable('pyright')
vim.lsp.enable('terraformls')
vim.lsp.enable('solc')
vim.lsp.config('elixirls', {
  cmd = { "elixir-ls" },
})
vim.lsp.enable('elixirls')
vim.lsp.config('copilot', {
  cmd = {
    vim.fn.system("pushd ~ > /dev/null && (asdf which node || which node) 2>/dev/null && popd > /dev/null"):gsub("\n$", ""),
    vim.fn.system("pushd ~ > /dev/null && (which copilot-language-server) 2>/dev/null && popd > /dev/null"):gsub("\n$", ""),
    '--stdio',
  },
})
vim.lsp.enable('copilot')

vim.api.nvim_create_autocmd('LspAttach', {
  group = "MyVimrc",
  callback = function(args)
    local bufnr = args.buf
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
    --   vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

    --   vim.keymap.set(
    --     'i',
    --     '<Tab>',
    --     function()
    --       if not vim.lsp.inline_completion.get() then
    --         return "<Tab>"
    --       end
    --     end,
    --     { expr = true, desc = 'LSP: accept inline completion', buffer = bufnr }
    --   )
    --   vim.keymap.set(
    --     'i',
    --     '<S-Tab>',
    --     vim.lsp.inline_completion.select,
    --     { desc = 'LSP: switch inline completion', buffer = bufnr }
    --   )
    -- end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting, bufnr) then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            id = client.id,
            timeout_ms = 10000,
          })
        end,
      })
    end
  end,
})


-- plugins
require("lazy").setup({
  spec = { { import = "plugins" } },
  checker = { enabled = true },
  rocks = { enabled = false },
})
