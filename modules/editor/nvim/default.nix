{pkgs, ...}: let
  treesitterGrammars = pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
    with p; [
      bash
      c
      cpp
      css
      dockerfile
      fish
      git_config
      git_rebase
      gitattributes
      gitcommit
      gitignore
      html
      javascript
      jsdoc
      json
      lua
      luadoc
      markdown
      markdown_inline
      nix
      python
      regex
      rust
      toml
      tsx
      typescript
      vim
      vimdoc
      yaml
    ]);
in {
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = false;

    extraPackages = with pkgs; [
      # Core search and runtime tools
      git
      fd
      ripgrep
      fzf
      tmux
      yazi

      # Python
      pyright
      ruff
      python3Packages.ipython

      # JavaScript / TypeScript / Web
      nodePackages.typescript-language-server
      nodePackages.prettier
      vscode-langservers-extracted
      tailwindcss-language-server
      emmet-language-server

      # Rust
      rust-analyzer
      cargo
      clippy
      rustfmt

      # Nix / Lua / Shell / Docs
      nixd
      alejandra
      statix
      deadnix
      lua-language-server
      stylua
      fish
      bash-language-server
      shellcheck
      shfmt
      taplo
      yaml-language-server
      marksman
    ];

    plugins = with pkgs.vimPlugins; [
      # Core UI
      catppuccin-nvim
      nvim-web-devicons
      lualine-nvim
      bufferline-nvim
      which-key-nvim
      snacks-nvim

      # Syntax
      treesitterGrammars
      nvim-ts-autotag

      # Completion
      blink-cmp
      friendly-snippets

      # LSP / format / lint
      nvim-lspconfig
      conform-nvim
      # nvim-lint

      # Editing and productivity
      mini-nvim
      guess-indent-nvim

      # Git and REPL
      gitsigns-nvim
      vim-slime

      # Required by several plugins
      plenary-nvim
    ];

    initLua = ''
      ${builtins.readFile ./lua/options.lua}
      ${builtins.readFile ./lua/keymaps.lua}
      ${builtins.readFile ./lua/autocmds.lua}
      ${builtins.readFile ./lua/ui.lua}
      ${builtins.readFile ./lua/snacks.lua}
      ${builtins.readFile ./lua/completion.lua}
      ${builtins.readFile ./lua/lsp.lua}
      ${builtins.readFile ./lua/format-lint.lua}
      ${builtins.readFile ./lua/git.lua}
      ${builtins.readFile ./lua/productivity.lua}
      ${builtins.readFile ./lua/run.lua}
    '';
  };
}
