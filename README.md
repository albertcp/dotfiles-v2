# Configuración de Neovim — C++, Python + IA (OpenCode Zen)

Archivo principal: `config_neovim.lua` → copiar a `~/.config/nvim/init.lua`

## Requisitos

- **Nerd Font** instalada en la terminal (para iconos):
  ```bash
  brew install --cask font-jetbrains-mono-nerd-font
  ```
  Luego configura tu terminal para usar "JetBrainsMono Nerd Font".

## Plugins instalados

| Plugin | GitHub | Función |
|---|---|---|
| lazy.nvim | https://github.com/folke/lazy.nvim | Gestor de paquetes |
| catppuccin | https://github.com/catppuccin/nvim | Tema de colores (macchiato) |
| alpha-nvim | https://github.com/goolord/alpha-nvim | Dashboard de inicio |
| lualine.nvim | https://github.com/nvim-lualine/lualine.nvim | Barra de estado inferior |
| bufferline.nvim | https://github.com/akinsho/bufferline.nvim | Pestañas de buffers |
| nvim-treesitter | https://github.com/nvim-treesitter/nvim-treesitter | Resaltado de sintaxis |
| mason.nvim | https://github.com/williamboman/mason.nvim | Instalador LSP / linters |
| mason-lspconfig | https://github.com/williamboman/mason-lspconfig.nvim | Puente Mason → lspconfig |
| nvim-lspconfig | https://github.com/neovim/nvim-lspconfig | Configuración de servidores LSP |
| nvim-cmp | https://github.com/hrsh7th/nvim-cmp | Autocompletado |
| cmp-nvim-lsp | https://github.com/hrsh7th/cmp-nvim-lsp | Fuente LSP para cmp |
| cmp-buffer | https://github.com/hrsh7th/cmp-buffer | Fuente buffer para cmp |
| cmp-path | https://github.com/hrsh7th/cmp-path | Fuente rutas para cmp |
| LuaSnip | https://github.com/L3MON4D3/LuaSnip | Snippets |
| cmp_luasnip | https://github.com/saadparwaiz1/cmp_luasnip | Puente LuaSnip → cmp |
| friendly-snippets | https://github.com/rafamadriz/friendly-snippets | Snippets para Python, C++, Lua y más |
| telescope.nvim | https://github.com/nvim-telescope/telescope.nvim | Búsqueda fuzzy |
| plenary.nvim | https://github.com/nvim-lua/plenary.nvim | Utilidades (dependencia) |
| nvim-tree.lua | https://github.com/nvim-tree/nvim-tree.lua | Árbol de archivos lateral |
| nvim-web-devicons | https://github.com/nvim-tree/nvim-web-devicons | Iconos de archivos |
| render-markdown.nvim | https://github.com/MeanderingProgrammer/render-markdown.nvim | Renderizar markdown en Neovim |
| markdown-preview.nvim | https://github.com/iamcco/markdown-preview.nvim | Preview de markdown en navegador |
| avante.nvim | https://github.com/yetone/avante.nvim | Chat IA estilo Cursor (sidebar, edición) |
| nui.nvim | https://github.com/MunifTanjim/nui.nvim | Componentes UI (dependencia) |
| nvim-lint | https://github.com/mfussenegger/nvim-lint | Linting extra (ruff, shellcheck) |
| nvim-notify | https://github.com/rcarriga/nvim-notify | Notificaciones modernas |
| noice.nvim | https://github.com/folke/noice.nvim | Interfaz moderna (cmdline, mensajes, popups) |
| nvim-colorizer | https://github.com/norcalli/nvim-colorizer.lua | Colores inline (#hex, rgb) |
| dressing.nvim | https://github.com/stevearc/dressing.nvim | Diálogos de entrada bonitos |
| which-key.nvim | https://github.com/folke/which-key.nvim | Popup de atajos al pulsar <leader> |
| indent-blankline | https://github.com/lukas-reineke/indent-blankline.nvim | Guías de indentación |
| todo-comments | https://github.com/folke/todo-comments.nvim | Resalta TODOs, FIXMEs, HACKs |

## Cómo activar

```bash
# 1. Copiar configuración
cp config_neovim.lua ~/.config/nvim/init.lua

# 2. Exportar API key de OpenCode Zen
export OPENAI_API_KEY="tu-api-key-de-opencode.ai/auth"

# 3. Abrir Neovim (se instalará todo automáticamente,
#    incluyendo parsers de treesitter: markdown, yaml)
nvim
```

Obtén tu API key gratis en https://opencode.ai/auth

### Proveedores disponibles (avante.nvim)

| Proveedor | Endpoint | Modelo |
|---|---|---|
| `opencode` (activo) | `https://opencode.ai/zen/v1` | `deepseek-v4-flash-free` |
| `opencode_gpt` (comentado) | `https://opencode.ai/zen/v1/responses` | `gpt-5.4-nano` |
| `opencode_legacy` (comentado) | `https://opencode.ai/zen/v1/chat/completions` | `deepseek-v4-flash-free` |

Para cambiar de proveedor: `:AvanteSwitchProvider <nombre>` o presionar `ga` en la sidebar.

## Funcionalidades

- **Dashboard de inicio** con alpha-nvim al abrir Neovim sin archivo (centrado, con iconos)
- **Syntax checking** integrado: LSP (clangd, pylsp, lua_ls) + linters (ruff, shellcheck) con iconos en la columna de diagnóstico
- **nvim-tree se abre automáticamente** junto al dashboard al iniciar en un directorio
- **Markdown renderizado** visualmente al abrir archivos `.md` y en las respuestas de Avante
- **Preview en navegador** con `<leader>mp`
- **OpenCode** integrado: avante.nvim para chat IA (sidebar estilo Cursor, header centrado y redondeado, borders rounded, highlights del tema catppuccin)
  - El thought content (razonamiento) del modelo se muestra en gris itálica
  - Los buffers de Avante se ocultan de la barra de pestañas (bufferline)
- **Barra de estado** con lualine.nvim (modo, git, diagnóstico, archivo)
- **Pestañas de buffers** con bufferline.nvim (con filtro para ocultar Avante y NvimTree)
- **Redimensionar ventanas** con `<A-=>` y `<A-->`
- **Guías de indentación** visuales con indent-blankline
- **Popup de atajos** con which-key al pulsar `<leader>`
- **Notificaciones modernas** con noice.nvim + nvim-notify
- **Diálogos de entrada bonitos** con dressing.nvim
- **Colores inline** (#hex, rgb, hsl) resaltados en el código
- **TODOs/FIXMEs** destacados y buscables con todo-comments

## Comandos / Atajos

### Dashboard (desde alpha-nvim)

| Tecla | Acción |
|---|---|
| `f` | Buscar archivos (Telescope) |
| `r` | Archivos recientes (Telescope) |
| `t` | Buscar texto (Telescope) |
| `e` | Nuevo archivo vacío |
| `o` | Abrir terminal OpenCode |
| `a` | Abrir Avante IA (chat) |

### Archivos y navegación

| Comando | Acción |
|---|---|
| `<leader>e` | Toggle árbol de archivos (nvim-tree) |
| `<leader>ef` | Foco en el árbol |
| `<leader>pv` | Explorador nativo de Neovim (`:Ex`) |
| `<leader>w` | Guardar archivo (`:w`) |
| `<leader>q` | Cerrar buffer actual / volver al dashboard si es el último |
| `<leader>Q` | Cerrar **todos** los buffers y mostrar el dashboard |
| `:qa` | Salir de Neovim por completo |

### Búsqueda (Telescope)

| Tecla | Acción |
|---|---|
| `<leader>ff` | Buscar archivos por nombre |
| `<leader>fg` | Buscar texto en archivos (grep) |
| `<leader>fb` | Lista de buffers abiertos |
| `<leader>fh` | Buscar ayuda de Neovim |

### LSP (C++ clangd, Python pylsp, Lua lua_ls)

| Tecla | Acción |
|---|---|
| `gd` | Ir a definición |
| `K` | Hover / documentación del símbolo |
| `gr` | Ver referencias |
| `<leader>di` | Ver diagnóstico flotante |
| `<leader>rn` | Renombrar símbolo |
| `<leader>ca` | Code action |
| `[d` | Ir al diagnóstico anterior |
| `]d` | Ir al diagnóstico siguiente |

### IA (OpenCode Zen)

| Tecla | Acción |
|---|---|
| `<leader>aa` | Avante: preguntar en sidebar |
| `<leader>ae` | Avante: editar selección (visual) |
| `ga` (sidebar) | Avante: cambiar modelo/provider |
| `r` (sidebar) | Avante: re-intentar petición |
| `e` (sidebar) | Avante: editar petición |
| `A` (sidebar) | Avante: aplicar todos los cambios |
| `a` (sidebar) | Avante: aplicar cambio bajo el cursor |
| `<leader>oc` | Toggle terminal OpenCode |
| `<leader>ft` | Buscar TODOs / FIXMEs (Telescope) |
| `<leader>nd` | Cerrar notificación activa |

### Markdown

| Tecla | Acción |
|---|---|
| `<leader>mp` | Preview Markdown en navegador |
| `<leader>ms` | Detener preview Markdown |

### Ventanas

| Comando | Acción |
|---|---|
| `<A-=>` | Aumentar ancho de ventana |
| `<A-->` | Reducir ancho de ventana |
| `<C-w>=` | Igualar tamaño de ventanas |
| `<C-w>v` | Dividir verticalmente |
| `<C-w>s` | Dividir horizontalmente |
| `<C-w>h/j/k/l` | Moverse entre ventanas |

> `<leader>` es `\` por defecto. Para cambiarlo añade `vim.g.mapleader = " "` al inicio del config.
