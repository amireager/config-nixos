
{ pkgs, ... }:

{
  # --- TERMINAL PACKAGES REQUIRED BY FISH CONFIG ---
  home.packages = with pkgs; [
    grc             # Generic Colouriser
    fd              # Fast find (Required for FZF commands)
    bat             # Modern cat (Required for FZF previews)
    fzf             # Fuzzy finder
    ripgrep         # Fast grep
  ];

  # --- ZOXIDE (Smart CD) Native Integration ---
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # --- DIRENV Native Integration ---
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;
  };

  # --- FISH SHELL CONFIGURATION ---
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # --- UI & GREETING ---
      set fish_greeting # Disable greeting

      # --- FZF CONFIGURATION (Catppuccin Mocha) ---
      set -gx FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
      set -gx FZF_CTRL_T_COMMAND  "$FZF_DEFAULT_COMMAND"
      set -gx FZF_ALT_C_COMMAND   'fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'
      set -gx FZF_PREVIEW_COMMAND 'bat --style=numbers --color=always --line-range :500 {}'
      
      set -gx FZF_DEFAULT_OPTS '--height 55% --layout=reverse --border rounded --preview-window=right:65%:wrap --color=fg:#cdd6f4,bg:#1e1e2e,hl:#f38ba8,fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8,info:#cba6f7,prompt:#89b4fa,pointer:#f5e0dc,marker:#f5e0dc,spinner:#f5e0dc,header:#f38ba8'

      # --- COMPLETION PAGER THEME ---
      set fish_pager_color_progress         cyan
      set fish_pager_color_background       --background=brblack
      set fish_pager_color_prefix           yellow --bold
      set fish_pager_color_completion       normal
      set fish_pager_color_description      green
      set fish_pager_color_selected_background --background=brblack
      set fish_pager_color_selected_prefix  yellow --bold
      set fish_pager_color_selected_completion white --bold
      set fish_pager_color_selected_description cyan

      # --- NAVIGATION BINDS (Arrow Keys Fix) ---
      bind \t complete
      bind \eOA up-or-search
      bind \eOB down-or-search
      bind \eOC forward-char
      bind \eOD backward-char
      bind -M insert \t complete
    '';

    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
    ];

    shellAliases = {
      # Eza (Modern ls)
      ls  = "eza --icons --group-directories-first --git";
      ll  = "eza -l --icons --group-directories-first --git --header";
      la  = "eza -la --icons --group-directories-first --git";
      lt  = "eza --tree --level=2 --icons --git";
      tree  = "eza --tree --icons --git";

      # Utilities
      cat   = "bat --style=plain";
      grep  = "rg";
      find  = "fd";
      top   = "btm";
      cd    = "z";
      cdi   = "zi";

      # NixOS management (Optimized for your flake)
      ns    = "nix shell";
      nd    = "nix develop";
      nb    = "nix build";
      nf    = "nix flake";
      nfu   = "nix flake update";
      nfs   = "sudo nixos-rebuild switch --flake .#nixos"; # Pointing to 'nixos' host
      nfc   = "nix flake check";
      ngc   = "sudo nix-collect-garbage --delete-older-than 14d";

      # Git
      gst   = "git status --short --branch";
      gaa   = "git add --all";
      gcmsg = "git commit -m";
      gp    = "git push";
      gpl   = "git pull --rebase";
      gl    = "git log --oneline --graph --decorate";
    };

    shellAbbrs = {
      gs   = "git status";
      ga   = "git add";
      gc   = "git commit -m";
      gp   = "git push";
      n    = "nvim";
      y    = "yazi";
    };
  };

  # --- STARSHIP PROMPT CONFIGURATION ---
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      command_timeout = 800;
      format = "$username$hostname$directory$git_branch$git_status$nix_shell$fill$cmd_duration$line_break$character";
      directory = {
        truncation_length = 4;
        truncate_to_repo = true;
        style = "bold #89b4fa";
        format = "[$path]($style) ";
      };
      git_branch = { symbol = " "; style = "bold #fab387"; };
      git_status = { style = "bold #f38ba8"; };
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
        success_symbol = "[  ](bold #a6e3a1)";
        error_symbol   = "[  ](bold #f38ba8)";
      };
      fill = { symbol = " "; };
    };
  };
}
