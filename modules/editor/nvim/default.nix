{ pkgs, ... }:

{
  # --- NEOVIM CONFIGURATION (Modern Lua Approach) ---
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # --- LUA-BASED CONFIGURATION ---
    initLua = ''
      -- Basic UI & Numbers
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.cursorline = true
      vim.opt.mouse = 'a'
      vim.opt.termguicolors = true

      -- Tabs & Indentation
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.smartindent = true

      -- Search & Clipboard
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.hlsearch = false -- Don't keep highlighting after search
      vim.opt.clipboard = 'unnamedplus'

      -- Undo & Backups (Clean & Organized)
      vim.opt.undofile = true
      vim.opt.swapfile = false
      vim.opt.backup = false

      -- Performance Fix: Fast ESC
      vim.opt.timeoutlen = 300
    '';

    # --- PLUGINS (Curated & Fast) ---
    plugins = with pkgs.vimPlugins; [
      # Syntax Highlighting (Treesitter)
      nvim-treesitter.withAllGrammars
      
      # File Explorer (Fast & Modern)
      nvim-tree-lua
      
      # Theme: Catppuccin (To match your Fish & Kitty)
      catppuccin-nvim

      # Status Line
      lualine-nvim
    ];

    # --- SYSTEM DEPENDENCIES (LSPs & Compilers) ---
    extraPackages = with pkgs; [
      # Standard compilers & tools
      gcc
      ripgrep
      fd
      wl-clipboard # System-wide clipboard for Wayland/Niri
      
      # LSPs (Language Servers)
      lua-language-server
      nil # Nix LSP
      pyright # Python LSP
    ];
  };

  # Activation script for custom setup (Optional)
  # home.activation.nvim-dirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   mkdir -p ~/.cache/nvim/{backup,swap,undo}
  # '';
}
