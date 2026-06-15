{...}: {
  # ============================================================
  #  USER SETTINGS
  #  User-level configuration: directories, default apps,
  #  and managed program configs (programs.*).
  # ============================================================

  # --- STANDARD USER DIRECTORIES ---
  # Creates & registers ~/Downloads, ~/Documents, ... like any normal OS
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # --- DEFAULT APPLICATIONS (double-click behavior) ---
  # NOTE: verify desktop file names with:
  #   ls ~/.nix-profile/share/applications /run/current-system/sw/share/applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Web
      "text/html" = ["zen-beta.desktop"];
      "x-scheme-handler/http" = ["zen-beta.desktop"];
      "x-scheme-handler/https" = ["zen-beta.desktop"];

      # Images
      "image/png" = ["imv.desktop"];
      "image/jpeg" = ["imv.desktop"];
      "image/gif" = ["imv.desktop"];
      "image/webp" = ["imv.desktop"];

      # Video & Audio
      "video/mp4" = ["mpv.desktop"];
      "video/x-matroska" = ["mpv.desktop"];
      "video/webm" = ["mpv.desktop"];
      "audio/mpeg" = ["mpv.desktop"];
      "audio/flac" = ["mpv.desktop"];

      # Documents
      "application/pdf" = ["org.pwmt.zathura.desktop"];

      # File manager
      "inode/directory" = ["thunar.desktop"];
    };
  };

  # ============================================================
  #  MANAGED PROGRAMS (programs.*)
  #  Tools enabled here instead of raw packages, so HM manages
  #  their config & shell integration.
  # ============================================================

  # --- FILE MANAGER (TUI) ---
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";
  };

  # --- SYSTEM MONITORS / FETCH / GIT TUI / FUZZY FILE TREE ---
  programs.btop.enable = true; # Beautiful resource monitor (replaces htop/bottom)
  programs.fastfetch.enable = true; # System info fetch on demand
  programs.lazygit.enable = true; # Friendly TUI for git
  programs.broot.enable = true; # Interactive tree navigator (`br`)

  # --- TLDR: community cheat-sheets (managed = auto cache update) ---
  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };

  # --- ATUIN: magical shell history (DB-backed, fuzzy, synced) ---
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    flags = ["--disable-up-arrow"]; # keep Up for normal history; Ctrl-R = atuin
    settings = {
      style = "compact";
      inline_height = 25;
      show_preview = true;
      enter_accept = false; # Enter edits the command, Tab runs it
    };
  };

  # --- TMUX: the de-facto terminal multiplexer ---
  programs.tmux = {
    enable = true;
    prefix = "C-a"; # friendlier than C-b
    baseIndex = 1; # windows/panes start at 1
    escapeTime = 10; # snappier ESC in nvim
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";
    extraConfig = ''
      # True color + undercurl passthrough for nvim
      set -ga terminal-overrides ",*256col*:Tc"

      # Intuitive split keys that keep the current path
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Vim-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Reload config quickly
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
    '';
  };

  # --- BAT: better `cat` (config; binary comes from terminal module) ---
  programs.bat = {
    enable = true;
    config = {
      theme = "ansi";
      style = "numbers,changes,header";
    };
  };

  # --- GIT & DELTA CONFIGURATION ---
  programs.git = {
    enable = true;

    # Sensible global ignores
    ignores = [
      ".direnv/"
      "result"
      "*.swp"
      ".DS_Store"
      ".idea/"
      ".vscode/"
    ];

    # Unified structured settings matching native .gitconfig syntax
    settings = {
      user = {
        name = "amireager";
        email = "parviziamir63@gmail.com";
      };

      alias = {
        st = "status -sb";
        lg = "log --oneline --graph --decorate --all";
        last = "log -1 HEAD --stat";
        unstage = "reset HEAD --";
        amend = "commit --amend --no-edit";
      };

      # Global Git optimization options
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true; # `git push` on a new branch just works
      fetch.prune = true; # drop deleted remote branches on fetch
      rebase.autoStash = true;
      diff.colorMoved = "default";
      merge.conflictStyle = "zdiff3"; # clearer conflict markers
      commit.verbose = true; # show the diff while writing a commit msg
      column.ui = "auto";
      branch.sort = "-committerdate"; # most-recent branches first
    };
  };

  # Pretty word-level diffs in the pager (separated from git module)
  programs.delta = {
    enable = true;
    enableGitIntegration = true; # explicitly enable integration as per modern specs
    options = {
      navigate = true; # use n / N to jump between diff hunks
      line-numbers = true;
      side-by-side = false;
      syntax-theme = "ansi";
    };
  };

  # --- GITHUB CLI ---
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  # Firefox as a stable fallback browser (managed as a program, not a package)
  programs.firefox.enable = true;
}
