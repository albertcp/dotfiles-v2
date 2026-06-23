-- ============================================================================
--  config_neovim.lua – Neovim para C++ y Python + IA vía OpenCode Zen
-- ============================================================================

-- Opciones básicas
vim.cmd("syntax on")
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.syntax = "ON"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end
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

  -- Tema global: catppuccin (si hay true color) o habamax (fallback 256 colores)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      if vim.o.termguicolors then
        vim.cmd.colorscheme("catppuccin-macchiato")
      else
        vim.cmd.colorscheme("habamax")
      end
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
        dashboard.button("o", "    OpenCode CLI", "<cmd>lua OpencodeToggle()<CR>"),
        dashboard.button("a", "    Avante IA", "<cmd>AvanteAsk<CR>"),
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
        ensure_installed = {},
        auto_install = false,
        highlight = { enable = false },
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
      local registry = require("mason-registry")
      for _, tool in ipairs({ "ruff", "shellcheck" }) do
        if not registry.is_installed(tool) then
          local ok, pkg = pcall(registry.get_package, tool)
          if ok then pkg:install() end
        end
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "pylsp", "lua_ls" },
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

      -- Python con pylsp
      vim.lsp.config("pylsp", {
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = { enabled = false },
              pyflakes = { enabled = false },
              mccabe = { enabled = false },
              autopep8 = { enabled = false },
              yapf = { enabled = false },
              jedi_completion = {
                enabled = true,
                include_params = true,
                include_class_objects = true,
                include_function_objects = true,
                fuzzy = true,
              },
              jedi_signature_help = { enabled = true },
              jedi_hover = { enabled = true },
              jedi_references = { enabled = true },
              jedi_documentation = { enabled = true },
              jedi_definition = {
                enabled = true,
                follow_imports = true,
                follow_builtin_imports = true,
              },
            },
          },
        },
      })

      -- Activar servidores
      vim.lsp.enable("clangd")
      vim.lsp.enable("pylsp")
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
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
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

  -- Markdown – renderizado en Neovim (también para Avante)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {},
    config = function()
      require("render-markdown").setup({
        file_types = { "markdown", "Avante" },
      })
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

  -- Notificaciones modernas (requerido por noice)
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#1e1e2e",
        fps = 60,
      })
      vim.notify = require("notify")
    end,
  },

  -- Interfaz moderna para cmdline, mensajes y popups
  {
    "folke/noice.nvim",
    dependencies = { "rcarriga/nvim-notify" },
    config = function()
      require("noice").setup({
        cmdline = { view = "cmdline_popup" },
        messages = { view = "mini" },
        popupmenu = { enabled = true },
        lsp = { progress = { enabled = true } },
        presets = { bottom_search = true, command_palette = true },
      })
    end,
  },

  -- Muestra colores inline (#hex, rgb, etc.)
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "*" })
    end,
  },

  -- Diálogos de entrada más bonitos
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({
        input = { enabled = true },
        select = { enabled = true },
      })
    end,
  },

  -- Popup con atajos al pulsar <leader>
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({})
    end,
  },

  -- Guías de indentación verticales
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope = { highlight = "Comment" },
      })
    end,
  },

  -- Resalta TODOs, FIXMEs, HACKs, etc.
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({})
    end,
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
        auto_set_highlight_group = false,
        auto_set_keymaps = true,
        auto_add_current_file = true,
        enable_token_counting = true,
        minimize_diff = true,
      },
      windows = {
        position = "right",
        width = 35,
        wrap = true,
        sidebar_header = {
          enabled = true,
          align = "center",
          rounded = true,
        },
        input = {
          prefix = " ",
          height = 8,
        },
        edit = {
          border = "rounded",
          start_insert = true,
        },
        ask = {
          floating = false,
          start_insert = true,
          border = "rounded",
        },
      },
      highlights = {
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
        conflict = { bg = "#363a4f", fg = "#eed49f" },
        accent_text = { fg = "#8aadf4" },
        inline_hint = { fg = "#6e738d" },
      },
      mappings = {
        sidebar = {
          ask = "<leader>aa",
          edit = "<leader>ae",
        },
      },
    },
  },

  -- CodeCompanion.nvim – Asistente IA tipo Continue.dev / JetBrains
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        http = {
          opencode_zen = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://opencode.ai/zen/v1",
                chat_url = "/chat/completions",
                api_key = "OPENAI_API_KEY",
              },
              schema = {
                model = {
                  default = "deepseek-v4-flash-free",
                },
              },
              opts = { stream = true, tools = true, vision = false },
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = "opencode_zen",
          slash_commands = {
            ["file"] = { opts = { provider = "telescope" } },
          },
        },
        inline = { adapter = "opencode_zen" },
      },
      display = {
        chat = {
          show_settings = false,
          show_token_count = true,
          start_in_insert_mode = false,
          window = {
            layout = "vertical",
            width = 0.45,
            height = 0.8,
            border = "rounded",
          },
        },
        diff = { enabled = true },
        inline = { layout = "vertical" },
      },
      opts = { log_level = "INFO", language = "English", send_code = true },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
      local map = vim.keymap.set
      map({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>",
        { desc = "Toggle CodeCompanion chat" })
      map({ "n", "v" }, "<leader>ci", "<cmd>CodeCompanion<cr>",
        { desc = "CodeCompanion inline assist" })
      map("v", "ga", "<cmd>CodeCompanionChat Add<cr>",
        { desc = "Añadir selección a chat" })
    end,
  },
})

-- Avante: highlight groups extra para que matchee con catppuccin-macchiato
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "catppuccin-macchiato",
  callback = function()
    local hl = vim.api.nvim_set_hl
    hl(0, "AvanteTitle",              { fg = "#8aadf4", bold = true })
    hl(0, "AvanteReversedTitle",      { fg = "#8aadf4", bold = true })
    hl(0, "AvanteSubtitle",           { fg = "#a6da95" })
    hl(0, "AvanteReversedSubtitle",   { fg = "#a6da95" })
    hl(0, "AvanteThirdTitle",         { fg = "#f5a97f" })
    hl(0, "AvanteReversedThirdTitle", { fg = "#f5a97f" })
    hl(0, "AvanteConflictCurrent",    { bg = "#363a4f", fg = "#eed49f" })
    hl(0, "AvanteConflictIncoming",   { bg = "#363a4f", fg = "#a6da95" })
    hl(0, "AvantePopupHint",          { fg = "#6e738d", italic = true })
    hl(0, "AvanteInlineHint",         { fg = "#6e738d" })
    hl(0, "AvantePromptInput",        { fg = "#cad3f5", bg = "#1e1e2e" })
    hl(0, "AvantePromptInputBorder",  { fg = "#6e738d" })
  end,
})

-- Terminal limpia: sin números de línea ni signcolumn
-- Terminal con colores neutros (para que opencode TUI se vea bien)
vim.g.terminal_ansi_colors = {
  "#000000", "#cc0000", "#4e9a06", "#c4a000",
  "#3465a4", "#75507b", "#06989a", "#d3d7cf",
  "#555753", "#ef2929", "#8ae234", "#fce94f",
  "#729fcf", "#ad7fa8", "#34e2e2", "#eeeeec",
}
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.statuscolumn = ""
  end,
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
  vim.cmd("rightbelow 80vsplit | terminal opencode")
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
map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Buscar TODOs / FIXMEs" })
map("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Cerrar notificación" })

-- ============================================================================
--  CÓMO USAR:
--  1. Copia este archivo a ~/.config/nvim/init.lua
--  2. Abre Neovim → se instalará lazy.nvim y todos los plugins
--  3. Configura tu API key de OpenCode Zen:
--     export OPENAI_API_KEY="tu-api-key-de-opencode.ai/auth"
--  4. Obtén tu API key gratis en https://opencode.ai/auth
--  5. IA:
--     Avante:  <leader>aa (preguntar), <leader>ae (editar selección)
--     CodeCompanion: <leader>cc (chat), <leader>ci (inline), ga (visual → añadir a chat)
--     OpenCode terminal: <leader>oc
-- ============================================================================
