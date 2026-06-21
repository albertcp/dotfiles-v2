-- ============================================================================
--  config_neovim.lua – Neovim para C++ y Python + IA vía OpenCode Zen
-- ============================================================================

-- Opciones básicas
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.syntax = "ON"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Desactivar netrw para usar nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local map = vim.keymap.set

-- Bootstrap lazy.nvim
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
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({

  -- Colores
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-macchiato")
    end,
  },

  -- Dashboard de inicio
  {
    "goolord/alpha-nvim",
    priority = 1000,
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- ========================================================================
      --  Subtítulo del dashboard — cámbialo aquí cuando quieras
      -- ========================================================================
      local subtitle = "🚀  coding + AI  •  by albertcp"
      -- ========================================================================

      dashboard.section.header.val = {
        "",
        "    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
        "    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
        "    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
        "    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
      }

      dashboard.section.subtitle = {
        type = "text",
        val = subtitle,
        opts = { position = "center", hl = "Comment" },
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "    Buscar archivos", "<cmd>Telescope find_files<CR>"),
        dashboard.button("r", "    Archivos recientes", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("t", "    Buscar texto", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("e", "    Nuevo archivo", "<cmd>ene <BAR> startinsert<CR>"),
        dashboard.button("o", "    OpenCode", "<cmd>lua OpencodeToggle()<CR>"),
        dashboard.button("q", "    Salir", "<cmd>qa<CR>"),
      }

      local version = vim.version()
      dashboard.section.footer.val = {
        "",
        "    Neovim " .. version.major .. "." .. version.minor .. "." .. version.patch,
      }

      local function top_padding()
        local total = #dashboard.section.header.val
          + 1 + 1 + 2
          + #dashboard.section.buttons.val
          + #dashboard.section.footer.val + 4
        return { type = "padding", val = math.max(0, math.floor((vim.fn.winheight(0) - total) / 3)) }
      end

      alpha.setup({
        layout = {
          top_padding(),
          dashboard.section.header,
          { type = "padding", val = 1 },
          dashboard.section.subtitle,
          { type = "padding", val = 2 },
          dashboard.section.buttons,
          dashboard.section.footer,
        },
        opts = dashboard.opts,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "alpha",
        callback = function()
          local win = vim.api.nvim_get_current_win()
          vim.api.nvim_set_option_value("winhighlight", "EndOfBuffer:Normal", { win = win })
        end,
      })
    end,
  },

  -- Línea de estado (barra inferior)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Pestañas de buffers (barra superior)
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "slant",
          show_buffer_close_icons = true,
          show_close_icon = false,
        },
      })
    end,
  },

  -- Treesitter – resaltado de sintaxis
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "c", "cpp", "python", "lua", "vimdoc", "markdown", "bash", "json", "yaml", "toml", "html", "css", "javascript", "typescript", "rust", "go" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Mason – instalador de LSP / linters / formatters
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "pyright", "lua_ls", "ruff", "shellcheck" },
        automatic_installation = true,
      })
    end,
  },

  -- LSP – diagnóstico, definiciones, hover, etc. (API Neovim 0.11+)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local on_attach = function(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        map("n", "gD", vim.lsp.buf.declaration, bufopts)
        map("n", "gd", vim.lsp.buf.definition, bufopts)
        map("n", "K", vim.lsp.buf.hover, bufopts)
        map("n", "gi", vim.lsp.buf.implementation, bufopts)
        map("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        map("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        map("n", "gr", vim.lsp.buf.references, bufopts)
        map("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
        map("n", "[d", vim.diagnostic.goto_prev, bufopts)
        map("n", "]d", vim.diagnostic.goto_next, bufopts)
        map("n", "<leader>di", vim.diagnostic.open_float, bufopts)
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Defaults globales para todos los servidores LSP
      vim.lsp.config("*", {
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- C++ con clangd
      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy" },
      })

      -- Python con pyright
      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      -- Activar servidores
      vim.lsp.enable("clangd")
      vim.lsp.enable("pyright")
      vim.lsp.enable("lua_ls")
    end,
  },

  -- Autocompletado (nvim-cmp) con fuente LSP
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Linting extra (ruff, shellcheck, etc.)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufWritePost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python = { "ruff" },
        bash = { "shellcheck" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufRead" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- Telescope – búsqueda fuzzy
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      map("n", "<leader>ff", builtin.find_files, {})
      map("n", "<leader>fg", builtin.live_grep, {})
      map("n", "<leader>fb", builtin.buffers, {})
      map("n", "<leader>fh", builtin.help_tags, {})
    end,
  },

  -- nvim-tree – Árbol de archivos en el lateral
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        update_focused_file = {
          enable = true,
          update_cwd = true,
        },
        renderer = {
          icons = {
            show = {
              git = true,
              folder = true,
              file = true,
            },
          },
        },
        actions = {
          open_file = {
            quit_on_open = false,
            window_picker = { enable = false },
          },
        },
      })

      -- Fondo oscuro en toda la ventana del árbol
      vim.api.nvim_create_autocmd("User", {
        pattern = "NvimTreeOpen",
        callback = function()
          vim.schedule(function()
            local bg = (vim.api.nvim_get_hl(0, { name = "Normal" }).bg or 0x1e1e2e)
            vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = bg })
            -- fillchars local para ocultar ~ en el árbol
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype == "NvimTree" then
                vim.wo[win].fillchars = "eob: "
              end
            end
          end)
        end,
      })

      map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle árbol de archivos" })
      map("n", "<leader>ef", "<cmd>NvimTreeFocus<CR>", { desc = "Foco en el árbol" })

      -- Abrir nvim-tree automáticamente al iniciar nvim en un directorio
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if vim.fn.argc() == 0 or vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
            require("nvim-tree.api").tree.open()
          end
        end,
      })
    end,
  },

  -- Markdown – renderizado en Neovim
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {},
    config = function()
      require("render-markdown").setup({})
    end,
  },

  -- Markdown – preview en navegador
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
  },

  -- Avante.nvim – Plugin de IA conectado a OpenCode Zen
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      provider = "opencode",
      auto_suggestions_provider = "opencode",
      providers = {
        opencode = {
          __inherited_from = "openai",
          api_key_name = "OPENAI_API_KEY",
          endpoint = "https://opencode.ai/zen/v1",
          model = "deepseek-v4-flash-free",
          extra_request_body = {
            temperature = 0.2,
            max_tokens = 4096,
          },
        },
        -- Alternativa para modelos GPT (Responses API):
        -- opencode_gpt = {
        --   __inherited_from = "openai",
        --   api_key_name = "OPENAI_API_KEY",
        --   endpoint = "https://opencode.ai/zen/v1/responses",
        --   model = "gpt-5.4-nano",
        -- },
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
      },
      mappings = {
        sidebar = {
          ask = "<leader>aa",
          edit = "<leader>ae",
        },
      },
    },
  },
})

-- Ocultar las ~ del final del buffer en toda la ventana
vim.opt.fillchars:append("eob: ")
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local bg = (vim.api.nvim_get_hl(0, { name = "Normal" }).bg or 0x1e1e2e)
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = bg })
  end,
})

-- Iconos en la columna de diagnóstico (syntax checking)
vim.fn.sign_define("DiagnosticSignError", { text = "󰅚", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "󰀪", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "󰋼", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌶", texthl = "DiagnosticSignHint" })

-- Toggle para OpenCode en terminal flotante
local opencode_win = nil
function _G.OpencodeToggle()
  if opencode_win and vim.api.nvim_win_is_valid(opencode_win) then
    vim.api.nvim_win_close(opencode_win, true)
    opencode_win = nil
    return
  end
  vim.cmd("15split | terminal opencode")
  opencode_win = vim.api.nvim_get_current_win()
  vim.cmd("startinsert")
end

-- Mostrar el dashboard en una ventana nueva a la derecha de nvim-tree
function _G.ShowDashboard()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "alpha" then
      return
    end
  end
  local has_normal = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype or ""
    if ft ~= "NvimTree" and ft ~= "alpha" then
      has_normal = true
      break
    end
  end
  if not has_normal then
    vim.cmd("rightbelow vnew")
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "NvimTree" then
        vim.api.nvim_win_set_width(win, 30)
        break
      end
    end
    local ok, alpha = pcall(require, "alpha")
    if ok then alpha.start(true) end
  end
end

-- Cerrar ventana / volver al dashboard si es la última
function _G.SmartClose()
  local current_ft = vim.bo[vim.api.nvim_get_current_buf()].filetype or ""
  local normal_wins = 0
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype or ""
    if ft ~= "NvimTree" and ft ~= "alpha" then
      normal_wins = normal_wins + 1
    end
  end
  if normal_wins <= 1 and current_ft ~= "NvimTree" and current_ft ~= "alpha" then
    vim.cmd("bd!")
    ShowDashboard()
  else
    vim.cmd("q")
  end
end

-- Cerrar todos los archivos y volver al dashboard
function _G.CloseAllFiles()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype or ""
    if ft ~= "NvimTree" and ft ~= "alpha" then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
  -- Cerrar buffers huérfanos (sin ventana)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local ft = vim.bo[buf].filetype or ""
    if not vim.api.nvim_buf_is_valid(buf) then goto continue end
    local wins = vim.fn.bufwinnr(buf)
    if wins == -1 and ft ~= "NvimTree" and ft ~= "alpha" then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
    ::continue::
  end
  ShowDashboard()
end

-- Mostrar dashboard automáticamente al cerrar todos los archivos
vim.api.nvim_create_autocmd("WinClosed", {
  callback = function()
    vim.schedule(function()
      ShowDashboard()
    end)
  end,
})

-- Atajos generales
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Guardar" })
map("n", "<leader>q", "<cmd>lua SmartClose()<CR>", { desc = "Cerrar ventana / volver al inicio" })
map("n", "<leader>Q", "<cmd>lua CloseAllFiles()<CR>", { desc = "Cerrar todos los archivos" })
map("n", "<leader>pv", vim.cmd.Ex, { desc = "Explorador nativo" })

-- Redimensionar ventanas (estilo VSCode)
map("n", "<A-=>", "<C-w>>", { desc = "Aumentar ancho de ventana" })
map("n", "<A-->", "<C-w><", { desc = "Reducir ancho de ventana" })

-- Markdown preview
map("n", "<leader>mp", "<cmd>MarkdownPreview<CR>", { desc = "Preview Markdown en navegador" })
map("n", "<leader>ms", "<cmd>MarkdownPreviewStop<CR>", { desc = "Detener preview Markdown" })

map("n", "<leader>oc", "<cmd>lua OpencodeToggle()<CR>", { desc = "Toggle OpenCode" })

-- ============================================================================
--  CÓMO USAR:
--  1. Copia este archivo a ~/.config/nvim/init.lua
--  2. Abre Neovim → se instalará lazy.nvim y todos los plugins
--  3. Configura tu API key de OpenCode Zen:
--     export OPENCODE_API_KEY="tu-api-key-de-opencode.ai/auth"
--     Avante leerá la variable OPENAI_API_KEY automáticamente.
--     También puedes reiniciar Neovim y ejecutar:
--       :let $OPENAI_API_KEY = "tu-api-key"
--  4. Obtén tu API key gratis en https://opencode.ai/auth
--  5. Usa <leader>aa para preguntar con IA en la sidebar
--  6. Usa <leader>ae para editar selección con IA
-- ============================================================================
