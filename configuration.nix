# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  boot = {
      loader = {
          grub = {
            enable = true;
	          version = 2;
	          device = "/dev/sda";
          };
      };
      kernelPackages = pkgs.linuxPackages_latest;
  };
  # Use the GRUB 2 boot loader.
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.etc."inputrc".text = ''
    set enable-keypad on
  '';
  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    curl
    htop
    manpages
    psmisc

    acpi
    acpitool
    sudo
    zip
    unzip
    which
    
    dunst
    notify-desktop
    
    pavucontrol
    mpv
    cava
    scrot
    feh
    imagemagick
    ranger
    zathura
    tint2
    paper-icon-theme
    obconf
    lxappearance
    networkmanagerapplet

    w3m
    udiskie
    tmux
    neofetch
    bar-xft
    i3lock-color
    xss-lock
    rofi
    lm_sensors
    adapta-gtk-theme
    clipit

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware = {
      pulseaudio = {
	      enable = true;
        #package = pkgs.pulseaudioFull;
        tcp.enable = true;
        tcp.anonymousClients.allowedIpRanges = [ "127.0.0.1" ];
      };
      trackpoint = {
        enable = true;
        emulateWheel = true;
        fakeButtons = true;
      };
      cpu = {
        intel = {
          updateMicrocode = true;
        };
      };
    
  };
  
  systemd.services.systemd-udev-settle.serviceConfig.ExecStart = ["" "${pkgs.coreutils}/bin/true"];

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  services = {
      # Enable the X11 windowing system.
    xserver = {
	    enable = true;
        layout = "us";
        desktopManager = {
          default = "none";
        };
        displayManager = {
          auto = {
            enable = true;
            user = "ciguatera";
          };
          sessionCommands = ''
            udiskie -a -s &
          '';
        };
        windowManager = {
          openbox.enable = true;
          default = "openbox";
        };
    };


    compton = {
	    enable = true;
      backend = "glx";
    };
    #thinkfan.enable = true;
    thermald.enable = true;
    tlp.enable = true;
    acpid = {
	    enable = true;
    };

    redshift = {
 	    enable = true;
      latitude = "45.4";
      longitude = "-75.7";
      temperature = {
	      day = 6500;
        night = 5000;
      };
    };
      
    logind = {
	    extraConfig = "IdleAction=ignore";
    };
  };

  fonts = {
      fontconfig ={
          enable = true;
      };
      enableFontDir = true;
      fonts = with pkgs;[
          font-awesome_4
	        inconsolata
          nerdfonts
      ];
  };
  
  programs = {
      light = {
        enable = true;
      };

      bash = {
	      enableCompletion = true;
      };
      slock.enable=true;
  };
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.ciguatera = {
    isNormalUser = true;
    home = "/home/ciguatera";
    extraGroups = ["wheel" "networkmanager" "audio" "video"];
    uid = 1000;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
