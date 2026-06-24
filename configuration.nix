{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    bluetooth.enable = true;
  };

  networking = {
    hostName = "nixos-btw";
    networkmanager.enable = true;
  };

  users.users.nyx = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
    packages = with pkgs; [
      tree
    ];
  };

  time.timeZone = "Europe/Belgrade";

  services = {
    xserver = {
      enable = true;
      xkb.layout = "ba";
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;

      wacom.enable = true;
      digimend.enable = true;
      inputClassSections = [
        ''
          Identifier "Wacom One by Wacom S Pen"
          MatchUSBID "0x56a:0x37a"
          MatchDevicePath "/dev/input/event*"
          MatchIsTablet "on"
          Driver "wacom"
        ''
      ];

      windowManager.qtile.enable = true;
    };

    udev = {
      enable = true;
      extraHwdb = ''
        evdev:input:b0x03v0x56ap0x37a*
        KEYBOARD_KEY_0=z
        KEYBOARD_KEY_70005=h
        KEYBOARD_KEY_700e0=0x1d
        KEYBOARD_KEY_70057=a
        KEYBOARD_KEY_70056=z
      '';
    };

    displayManager.ly.enable = true;
    
    blueman.enable = true;
    printing.enable = true;

    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;

    thermald.enable = true;
    tlp.enable = true;

    pipewire = {
      enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;

      pulse.enable = true;
      jack.enable = true;
    };

    "06cb-009a-fingerprint-sensor" = {
      enable = true;
      backend = "python-validity";
    };
  };

  security.rtkit.enable = true;

  programs = {
    firefox.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    gamemode.enable = true;

    cdemu.enable = true;
    cdemu.gui = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libice
        libsm
        libx11
        libxi
        libxcursor
        libxrandr
        libGL
        fontconfig
        freetype
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    alacritty
    brightnessctl
    git
    protonup-qt
    pcmanfm
    pwvucontrol
    wget
    xclip
    maim
    xev
    zip
    unzip
    usbutils
    udiskie
    udisks
    image-roll
    btop
    steam-run-free
    baobab
    wineWow64Packages.stable
    lutris
    rofi
    picom
    rar
    unrar
    ripgrep
    nil
    nixpkgs-fmt
    gcc
    nodejs
    alsa-utils
    libwacom
    kdePackages.wacomtablet
    config.boot.kernelPackages.digimend
    evemu
    evtest
    xinit
  ];

  fonts = {
     enableDefaultPackages = true;
     fontDir.enable = true;

     packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.symbols-only
        nerd-fonts.departure-mono
     ];

     fontconfig = {
        antialias = true;
     };
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11"; 
}
