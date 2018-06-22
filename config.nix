with (import <nixpkgs>{});
{
  allowUnfree = true;
  allowBroken = false;
	packageOverrides = pkgs: with pkgs; {
    texlive-custom = texlive.combine{
      inherit (texlive) scheme-basic latexmk xetex;
    };
    myncmpcpp = ncmpcpp.override{
      clockSupport = true;
    };
    myvim=vim_configurable.customize{
      name = "vim";
      vimrcConfig.customRC= builtins.readFile(./vimrc);
      vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
      vimrcConfig.vam.pluginDictionaries = [
        {
          names = [
             "lightline-vim"
             "UltiSnips"
             "vim-snippets"
             "Supertab"
             "vimtex"
             "ale"
             "commentary"
          ];
        }
      ];
    };
    all = buildEnv{
      inherit ((import <nixpkgs/nixos> {}).config.system.path);
      extraOutputsToInstall = [ "man" ];
      name = "all";
      paths = with pkgs;[
        nix-repl
        keepassxc
        myvim
        transmission-gtk
        gnome3.zenity
        streamlink
        youtube-dl
        xdotool
        xorg.xwininfo
        wmctrl
        gcolor2
        p7zip
        texlive-custom
        go-mtpfs
        myncmpcpp
        openmw
        retroarch
        discord
        pcmanfm
        xst
        mpd
        mpc_cli
      ];
    };
	};
}
