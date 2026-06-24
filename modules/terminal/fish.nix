{
  pkgs,
  lib,
  ...
}: let
  # Change these to your real flake targets.
  nixosHost = "nixos";
  homeTarget = "amir@nixos";
in {
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

    # Custom functions are loaded lazily by fish when they are first used.
    functions = {
      # Dynamic completion for local NixOS flake hosts.
      __fish_nixos_flake_hosts = ''
        set -l flake_path "."

        if test -f flake.nix
          command nix flake show --json $flake_path 2>/dev/null \
            | command jq -r '.nixosConfigurations // {} | keys[]?' 2>/dev/null \
            | string replace -r '^' '.#'
        end
      '';

      # Fast helper for common NixOS rebuild commands.
      nr = ''
        if test (count $argv) -eq 0
          echo "Usage: nr switch|test|boot|build|dry-build|dry-activate|vm|generations [extra args]"
          return 1
        end

        set -l action $argv[1]
        set -e argv[1]

        switch $action
          case switch
            sudo nixos-rebuild switch --flake .#${nixosHost} $argv
          case test
            sudo nixos-rebuild test --flake .#${nixosHost} $argv
          case boot
            sudo nixos-rebuild boot --flake .#${nixosHost} $argv
          case build
            nixos-rebuild build --flake .#${nixosHost} $argv
          case dry-build
            nixos-rebuild dry-build --flake .#${nixosHost} $argv
          case dry-activate
            sudo nixos-rebuild dry-activate --flake .#${nixosHost} $argv
          case vm
            nixos-rebuild build-vm --flake .#${nixosHost} $argv
          case generations
            nixos-rebuild list-generations $argv
          case '*'
            echo "Unknown action: $action"
            return 1
        end
      '';
    };

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

      # --- NIXOS-REBUILD COMPLETIONS ---
      complete -c nixos-rebuild -f
      complete -c nixos-rebuild -n "not __fish_seen_subcommand_from switch boot test build dry-build dry-activate edit build-vm build-vm-with-bootloader list-generations repl" -a "switch" -d "Build, activate and make default"
      complete -c nixos-rebuild -n "not __fish_seen_subcommand_from switch boot test build dry-build dry-activate edit build-vm build-vm-with-bootloader list-generations repl" -a "boot" -d "Build and make default for next boot"
      complete -c nixos-rebuild -n "not __fish_seen_subcommand_from switch boot test build dry-build dry-activate edit build-vm build-vm-with-bootloader list-generations repl" -a "test" -d "Build and activate until next boot"
      complete -c nixos-rebuild -n "not __fish_seen_subcommand_from switch boot test build dry-build dry-activate edit build-vm build-vm-with-bootloader list-generations repl" -a "build" -d "Build without activation"
      complete -c nixos-rebuild -n "not __fish_seen_subcommand_from switch boot test build dry-build dry-activate edit build-vm build-vm-with-bootloader list-generations repl" -a "dry-build" -d "Show what would be built"
      complete -c nixos-rebuild -n "not __fish_seen_subcommand_from switch boot test build dry-build dry-activate edit build-vm build-vm-with-bootloader list-generations repl" -a "dry-activate" -d "Show what activation would do"
      complete -c nixos-rebuild -n "not __fish_seen_subcommand_from switch boot test build dry-build dry-activate edit build-vm build-vm-with-bootloader list-generations repl" -a "edit" -d "Open configuration in editor"
      complete -c nixos-rebuild -n "not __fish_seen_subcommand_from switch boot test build dry-build dry-activate edit build-vm build-vm-with-bootloader list-generations repl" -a "build-vm" -d "Build a VM"
      complete -c nixos-rebuild -n "not __fish_seen_subcommand_from switch boot test build dry-build dry-activate edit build-vm build-vm-with-bootloader list-generations repl" -a "build-vm-with-bootloader" -d "Build a VM with bootloader"
      complete -c nixos-rebuild -n "not __fish_seen_subcommand_from switch boot test build dry-build dry-activate edit build-vm build-vm-with-bootloader list-generations repl" -a "list-generations" -d "List NixOS generations"
      complete -c nixos-rebuild -n "not __fish_seen_subcommand_from switch boot test build dry-build dry-activate edit build-vm build-vm-with-bootloader list-generations repl" -a "repl" -d "Open Nix REPL"

      complete -c nixos-rebuild -l flake -r -a '(__fish_nixos_flake_hosts)' -d "Use a Nix flake"
      complete -c nixos-rebuild -l upgrade -d "Update channels before rebuilding"
      complete -c nixos-rebuild -l upgrade-all -d "Update all channels before rebuilding"
      complete -c nixos-rebuild -l rollback -d "Rollback to previous generation"
      complete -c nixos-rebuild -l install-bootloader -d "Install bootloader"
      complete -c nixos-rebuild -l fast -d "Skip unnecessary steps"
      complete -c nixos-rebuild -l use-remote-sudo -d "Use sudo on target host"
      complete -c nixos-rebuild -l target-host -r -d "Deploy to target host"
      complete -c nixos-rebuild -l build-host -r -d "Build on remote host"
      complete -c nixos-rebuild -l profile-name -r -d "Use a custom profile name"
      complete -c nixos-rebuild -l option -x -d "Set a Nix option"
      complete -c nixos-rebuild -l builders -x -d "Set Nix builders"
      complete -c nixos-rebuild -l max-jobs -x -d "Set max build jobs"
      complete -c nixos-rebuild -l cores -x -d "Set build cores"
      complete -c nixos-rebuild -l impure -d "Allow impure flake evaluation"
      complete -c nixos-rebuild -l show-trace -d "Show full Nix evaluation trace"
      complete -c nixos-rebuild -l verbose -d "Verbose output"
      complete -c nixos-rebuild -l help -d "Show help"

      # --- NR HELPER COMPLETIONS ---
      complete -c nr -f
      complete -c nr -n "not __fish_seen_subcommand_from switch test boot build dry-build dry-activate vm generations" -a "switch" -d "sudo nixos-rebuild switch"
      complete -c nr -n "not __fish_seen_subcommand_from switch test boot build dry-build dry-activate vm generations" -a "test" -d "sudo nixos-rebuild test"
      complete -c nr -n "not __fish_seen_subcommand_from switch test boot build dry-build dry-activate vm generations" -a "boot" -d "sudo nixos-rebuild boot"
      complete -c nr -n "not __fish_seen_subcommand_from switch test boot build dry-build dry-activate vm generations" -a "build" -d "nixos-rebuild build"
      complete -c nr -n "not __fish_seen_subcommand_from switch test boot build dry-build dry-activate vm generations" -a "dry-build" -d "nixos-rebuild dry-build"
      complete -c nr -n "not __fish_seen_subcommand_from switch test boot build dry-build dry-activate vm generations" -a "dry-activate" -d "sudo nixos-rebuild dry-activate"
      complete -c nr -n "not __fish_seen_subcommand_from switch test boot build dry-build dry-activate vm generations" -a "vm" -d "nixos-rebuild build-vm"
      complete -c nr -n "not __fish_seen_subcommand_from switch test boot build dry-build dry-activate vm generations" -a "generations" -d "nixos-rebuild list-generations"
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

      # Nix
      ns = "nix shell";
      nd = "nix develop";
      nb = "nix build";
      nf = "nix flake";
      nfu = "nix flake update";
      nfc = "nix flake check";
      ngc = "sudo nix-collect-garbage --delete-older-than 14d";
      nopt = "nix-output-monitor";

      # Home Manager shortcuts
      hm = "home-manager";
      hms = "home-manager switch --flake .#${homeTarget}";
      hmb = "home-manager build --flake .#${homeTarget}";
      hmg = "home-manager generations";
      hme = "home-manager expire-generations '-7 days'";

      # NixOS rebuild shortcuts
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos#${nixosHost}";
      nrt = "sudo nixos-rebuild test --flake .#${nixosHost}";
      nrb = "nixos-rebuild build --flake .#${nixosHost}";
      nrd = "nixos-rebuild dry-build --flake .#${nixosHost}";
      nrv = "nixos-rebuild build-vm --flake .#${nixosHost}";
      nlg = "nixos-rebuild list-generations";

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

      sw = "sudo nixos-rebuild switch --flake .#${nixosHost}";
      tst = "sudo nixos-rebuild test --flake .#${nixosHost}";
      bld = "nixos-rebuild build --flake .#${nixosHost}";
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
