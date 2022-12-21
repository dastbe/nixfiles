{ config, pkgs, ... }:


let
  pkgsUnstable = import <nixpkgs-unstable> {};
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "dastbe";
  home.homeDirectory = "/Users/dastbe";
  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = [
    pkgsUnstable.awscli2
    pkgs.bat
    pkgs.bazelisk
    pkgs.bottom
    pkgs.cargo
    pkgs.du-dust
    pkgsUnstable.devbox
    pkgs.gh
    pkgs.git
    pkgsUnstable.git-branchless
    pkgs.go
    pkgs.htop
    pkgs.iterm2
    pkgs.kitty
    pkgs.lima
    pkgs.nodejs
    pkgs.procs
    pkgs.protobuf
    pkgs.ripgrep
    pkgs.ruby
    pkgs.rustc
    pkgs.tmux
    pkgs.yarn
    pkgs.zsh
    pkgsUnstable.etcd_3_5
    pkgsUnstable.nodePackages.graphite-cli
  ];

  programs.git = {
    enable = true;

    userName = "David Bell";
    userEmail = "david@dbell.dev";

    aliases = {
      co = "checkout";
      st = "status";
      fixup = "commit --fixup HEAD";
    };

    delta = {
      enable = true;
      options = {
        nagivate = true;
      };
    };

    extraConfig = {
      core = {
        editor = "vim";
        whitespace = "trailing-space,space-before-tab";
        excludesfile = "~/.gitignore";
      };
      web = {
        browser = "chrome";
      };
      rerere = {
        enabled = "1";
        autoupdate = "1";
      };
      push = {
        default = "simple";
      };
      diff = {
        tool = "vimdiff";
        colorMoved = "default";
      };
      difftool = {
        prompt = false;
      };
      merge = {
        tool = "vimdiff";
        conflictstyle = "diff3";
      };
      branch = {
        autosetuprebase = "always";
        autosetupmerge = "always";
      };
      rebase = {
        autosquash = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile vim/vimrc;
    plugins = with pkgs.vimPlugins; [
      vim-colorschemes
    ];
  };

  programs.zsh = {
    enable = true;
    completionInit = "autoload -Uz compinit promptinit && compinit && promptinit";
    enableSyntaxHighlighting = true;
    defaultKeymap = "viins";
    
    sessionVariables = {
      EDITOR = "vim";
    };

    shellAliases = {
      cat = "bat";
      ll = "ls -l";
    };

    initExtra = ''
      autoload -Uz vcs_info colors
      colors

      zstyle ':vcs_info:*' enable git
      zstyle ':vcs_info:git*' formats "(%{$fg[blue]%}%b%{$reset_color%})"
      precmd() {
        vcs_info
      }
      setopt prompt_subst

      NEWLINE='''$'\n'
      PROMPT='%{''$fg[red]%}%n%{''$reset_color%} on %{''$fg[blue]%}%m%{''$reset_color%} in %{''$fg[magenta]%}%~%{''$reset_color%} ''${vcs_info_msg_0_}''${NEWLINE}'
      RPROMPT='''
    '';
  };
}
