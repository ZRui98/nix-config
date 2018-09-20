{pkgs}:
let
  customPlugins.vim-indentLine = pkgs.vimUtils.buildVimPlugin {
    name = "vim-indentLine";
    src = pkgs.fetchFromGitHub {
      owner = "Yggdroot";
      repo = "indentLine";
      rev = "82ec57f8df3f642b0b3d43361e7b1a70f1a406d0";
      sha256 = "15gxgsslzwrm2kn1ccm9hqg5yqr4gj08ckp5bxqhmfhnc1famapa";
    };
  };
in {
  allowUnfree = true;
  allowBroken = false;
  packageOverrides = pkgs: with pkgs; rec {
    texlive-custom = texlive.combine{
      inherit (texlive) scheme-basic latexmk xetex;
    };
    myncmpcpp = ncmpcpp.override{
      clockSupport = true;
    };
    myneovim = neovim.override{
      vimAlias = true;
      configure = {
        customRC = builtins.readFile(./vimrc);
        vam.knownPlugins = pkgs.vimPlugins // customPlugins;
        vam.pluginDictionaries = [
          {
            names = [
               "lightline-vim"
               "UltiSnips"
               "vim-snippets"
               "Supertab"
               "vimtex"
               "ale"
               "commentary"
               "vim-nix"
               "vim-indentLine"
               "vim-surround"
               "vim-fugitive"
            ];
          }
        ];
      };
    };
    all = with pkgs; buildEnv{
      extraOutputsToInstall = [ "man" ];
      name = "all";
      paths = [
        /* media */
        streamlink
        youtube-dl
        retroarch
        mpd
        mpc_cli
        myncmpcpp
        crawlTiles
        transmission-gtk

        /* chat */
        discord
        irssi

        /* utilities */
        xfce.thunar
        ffmpegthumbnailer
        ranger
        jmtpfs

        myneovim
        gnome3.zenity
        xdotool
        xorg.xwininfo
        wmctrl
        gcolor2
        p7zip
        texlive-custom
        xst
        ffmpeg
        keepassxc
        zathura
        w3m
        manpages
        calcurse
        moreutils
        firefox
      ];
    };
  };
}
