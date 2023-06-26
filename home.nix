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
    pkgs.black
    pkgs.cargo
    pkgs.docker
    pkgs.ffmpeg
    pkgs.gcc
    pkgs.gh
    pkgs.google-java-format
    pkgs.htop
    pkgs.jq
    pkgs.lazygit
    pkgs.nodejs-16_x
    pkgs.nodePackages.prettier
    pkgs.libopus
    pkgs.libsndfile
    pkgs.pre-commit
    pkgs.python3
    pkgs.python3Packages.flake8
    pkgs.python3Packages.pipx
    pkgs.python3Packages.soundfile
    pkgs.poetry
    pkgs.ripgrep
    pkgs.ruff
    pkgs.rustc
    pkgs.stylua
    pkgs.sumneko-lua-language-server
    pkgs.tree
    pkgs.tree-sitter
    pkgs.wget
    pkgs.whois
    pkgs.sshfs
    pkgs.yarn
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bat.enable = true;

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = ''
      lua <<EOF

      local status, ts_install = pcall(require, "nvim-treesitter.install")
        if(status) then
          ts_install.compilers = { "${pkgs.gcc}/bin/gcc" }
        end

      require "user.impatient"
      require "user.options"
      require "user.keymaps"
      require "user.plugins"
      require "user.autocommands"
      require "user.colorscheme"
      require "user.cmp"
      require "user.telescope"
      require "user.gitsigns"
      require "user.treesitter"
      require "user.autopairs"
      require "user.comment"
      require "user.nvim-tree"
      require "user.bufferline"
      require "user.lualine"
      require "user.toggleterm"
      require "user.project"
      require "user.illuminate"
      require "user.indentline"
      require "user.alpha"
      require "user.lsp"
      require "user.dap"
      require "user.whichkey"
      require "user.copilot"

      EOF
    '';
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
      set -g set-clipboard on
      set -ag terminal-overrides "vte*:XT:Ms=\\E]52;c;%p2%s\\7,xterm*:XT:Ms=\\E]52;c;%p2%s\\7"
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
      hs = "LD_LIBRARY_PATH='' home-manager switch";
    };
    initExtra = ''
      if [ -f ~/.work_settings.sh ]; then
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
    userName = "Jon Roes";
    userEmail = "jroes@jroes.net";
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
  home.file.".config/nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/nvim/lua";
  home.file.".config/nvim/plugins".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixfiles/nvim/plugins";

  home.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib/:/usr/lib/x86_64-linux-gnu";
    EDITOR = "vim";
    FLYCTL_INSTALL = "${config.home.homeDirectory}/.fly";
    PATH = "$FLYCTL_INSTALL/bin:$PATH";
  };
}
