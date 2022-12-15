{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jroes";
  home.homeDirectory = builtins.getEnv "HOME";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  home.packages = [
    pkgs.python3
    pkgs.nodejs-16_x
    pkgs.nodePackages.prettier
    pkgs.python3Packages.flake8
    pkgs.stylua
    pkgs.google-java-format
    pkgs.wget
    pkgs.jq
    pkgs.ripgrep
    pkgs.tree
    pkgs.gh
    pkgs.pre-commit
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bat.enable = true;

  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins "cpu-usage ram-usage weather"
          set -g @dracula-show-powerline true
          set -g @dracula-show-location false
          set -g @dracula-refresh-rate 10
        '';
      }
    ];

    extraConfig = ''
      set -g mouse on
      set-option -sa terminal-overrides ',xterm-256color:RGB'
    '';
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    history.extended = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git-extras"
        "git"
        "github"
        "ssh-agent"
      ];
    };
    shellAliases = {
      hs = "home-manager switch";
    };
    initExtra = ''
      if [ -f ~/work_settings.sh ]; then
        source ~/.work_settings.sh
      fi
    '';
  };
  
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      aws.style = "bold #ffb86c";
      cmd_duration.style = "bold #f1fa8c";
      directory.style = "bold #50fa7b";
      hostname.style = "bold #ff5555";
      git_branch.style = "bold #ff79c6";
      git_status.style = "bold #ff5555";
      username = {
        format = "[$user]($style) on ";
        style_user = "bold #bd93f9";
      };
      character = {
        success_symbol = "[λ](bold #f8f8f2)";
        error_symbol = "[λ](bold #ff5555)";
      };
      gcloud.disabled = true;
    };
  };

  programs.git = {
    enable = true;
    extraConfig = {
      pull.rebase = true;
    };
  };
  
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file.".config/alacritty".source = ./alacritty;
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/nvim";

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
