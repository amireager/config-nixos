{
  pkgs,
  hostname,
  flakePath,
  ...
}: {
  # --- TERMINAL PACKAGES REQUIRED BY FISH CONFIG ---
  home.packages = with pkgs; [
    # Core shell tools
    fd
    bat
    fzf
    ripgrep
    jq

    # Modern replacements
    eza
    yazi

    # Better completion engine for many CLIs
    carapace

    # Nix workflow helpers
    nh
    nix-output-monitor

    # Optional colorizer. Keep it installed, but do not force-wrap commands.
    grc
  ];

  # --- ZOXIDE: SMART CD ---
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = ["--cmd" "z"];
  };

  # --- DIRENV: PROJECT ENVIRONMENT LOADING ---
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;
    silent = true;
  };

  # --- FZF: FUZZY FINDER ---
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --type d --strip-cwd-prefix --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 55%"
      "--layout=reverse"
      "--border rounded"
      "--preview-window=right:65%:wrap"
      "--color=fg:#cdd6f4,bg:#1e1e2e,hl:#f38ba8,fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8,info:#cba6f7,prompt:#89b4fa,pointer:#f5e0dc,marker:#f5e0dc,spinner:#f5e0dc,header:#f38ba8"
    ];
  };

  # --- CARAPACE: EXTRA COMPLETIONS FOR MULTI-LEVEL COMMANDS ---
  programs.carapace = {
    enable = true;
    enableFishIntegration = true;
  };

  # --- FISH SHELL CONFIGURATION ---
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # --- UI & GREETING ---
      set -g fish_greeting

      # --- FISH BEHAVIOR ---
      set -g fish_autosuggestion_enabled 1
      set -g fish_key_bindings fish_default_key_bindings

      # --- DEFAULT EDITOR ---
      set -gx EDITOR nvim
      set -gx VISUAL nvim
      set -gx PAGER "bat --plain"
      set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

      # --- FZF PREVIEW ---
      set -gx FZF_PREVIEW_COMMAND 'bat --style=numbers --color=always --line-range :500 {}'

      # --- CATPPUCCIN MOCHA: FISH COLORS ---
      set -g fish_color_normal cdd6f4
      set -g fish_color_command 89b4fa
      set -g fish_color_param f2cdcd
      set -g fish_color_keyword f38ba8
      set -g fish_color_quote a6e3a1
      set -g fish_color_redirection f5c2e7
      set -g fish_color_end fab387
      set -g fish_color_error f38ba8
      set -g fish_color_gray 6c7086
      set -g fish_color_selection --background=313244
      set -g fish_color_search_match --background=313244
      set -g fish_color_option a6e3a1
      set -g fish_color_operator f5c2e7
      set -g fish_color_escape eba0ac
      set -g fish_color_autosuggestion 6c7086
      set -g fish_color_cancel f38ba8

      # --- COMPLETION PAGER THEME ---
      set -g fish_pager_color_progress cyan
      set -g fish_pager_color_background --background=1e1e2e
      set -g fish_pager_color_prefix f9e2af --bold
      set -g fish_pager_color_completion cdd6f4
      set -g fish_pager_color_description a6e3a1
      set -g fish_pager_color_selected_background --background=313244
      set -g fish_pager_color_selected_prefix f9e2af --bold
      set -g fish_pager_color_selected_completion cdd6f4 --bold
      set -g fish_pager_color_selected_description 89b4fa

      # --- KEY BINDINGS ---
      bind \t complete
      bind \eOA up-or-search
      bind \eOB down-or-search
      bind \eOC forward-char
      bind \eOD backward-char
      bind -M insert \t complete

    '';

    plugins = [
      {
        name = "colored-man-pages";
        src = pkgs.fishPlugins.colored-man-pages.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];

    shellAliases = {
      # Eza
      ls = "eza --icons --group-directories-first --git";
      ll = "eza -l --icons --group-directories-first --git --header";
      la = "eza -la --icons --group-directories-first --git --header";
      lt = "eza --tree --level=2 --icons --git";
      tree = "eza --tree --icons --git";

      # Utilities
      cat = "bat --style=plain";
      grep = "rg";
      find = "fd";
      top = "btop";
      cdi = "zi";

      # NixOS / Home Manager (powered by nh)
      ns = "nix shell";
      nd = "nix develop";
      nfu = "nix flake update";
      nfc = "nix flake check";

      # Using nh for system rebuilds (much faster, pretty output)
      nrf = "sudo nixos-rebuild switch --flake ${flakePath}#${hostname}";
      nrs = "nh os switch";
      nrt = "nh os test";
      nrb = "nh os build";
      hms = "nh home switch";
      hmb = "nh home build";

      # Clean up older generations
      # clean = "nh clean all";

      # Git
      gst = "git status --short --branch";
      gaa = "git add --all";
      gl = "git log --oneline --graph --decorate";
    };

    shellAbbrs = {
      gs = "git status";
      ga = "git add";
      gc = "git commit -m";
      gco = "git checkout";
      gcb = "git checkout -b";
      gp = "git push";
      gpl = "git pull --rebase";

      n = "nvim";
      y = "yazi";

      sw = "nh os switch";
      tst = "nh os test";
      bld = "nh os build";
    };
  };

  # --- STARSHIP PROMPT CONFIGURATION ---
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      command_timeout = 500;
      scan_timeout = 10;

      format = "$username$hostname$directory$git_branch$git_status$nix_shell$fill$cmd_duration$line_break$character";

      directory = {
        truncation_length = 4;
        truncate_to_repo = true;
        style = "bold #89b4fa";
        format = "[$path]($style) ";
      };

      git_branch = {
        symbol = " ";
        style = "bold #fab387";
      };

      git_status = {
        style = "bold #f38ba8";
        format = "([$all_status$ahead_behind]($style) )";
        conflicted = "=";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
        up_to_date = "";
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };

      nix_shell = {
        symbol = "❄️ ";
        style = "bold #89b4fa";
        format = "[$symbol$state]($style) ";
      };

      cmd_duration = {
        min_time = 1500;
        format = "[$duration](bold #f9e2af) ";
      };

      character = {
        success_symbol = "[❯](bold #a6e3a1)";
        error_symbol = "[❯](bold #f38ba8)";
        vimcmd_symbol = "[❮](bold #89b4fa)";
      };

      fill = {
        symbol = " ";
      };
    };
  };
}
