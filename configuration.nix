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

  hardware.graphics = {
     enable = true;
     enable32Bit = true;
  };
  hardware.bluetooth.enable = true;

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Belgrade";

  services.xserver = {
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
  services.udev.enable = true;

  services.udev.extraHwdb =''
    evdev:input:b0x03v0x56ap0x37a*
      KEYBOARD_KEY_0=z
      KEYBOARD_KEY_70005=h
      KEYBOARD_KEY_700e0=0x1d
      KEYBOARD_KEY_70057=a
      KEYBOARD_KEY_70056=z
  '';

  services.displayManager.ly.enable = true;
  services.blueman.enable = true;

  services.printing.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;

  services.thermald.enable = true;
  services.tlp.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;
    jack.enable = true;
  };

  users.users.nyx = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.light.enable = true;
  programs.firefox.enable = true;
  programs.steam = {
     enable = true;
     remotePlay.openFirewall = true;
     dedicatedServer.openFirewall = true;
     gamescopeSession.enable = true;
     extraCompatPackages = with pkgs; [
        proton-ge-bin
     ];
  };
  programs.gamemode.enable = true;
  programs.cdemu.enable = true;
  programs.cdemu.gui = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXi
    xorg.libXcursor
    xorg.libXrandr
    libGL
    fontconfig
    freetype
  ];

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    alacritty
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
  ];

  fonts = {
     enableDefaultPackages = true;
     fontDir.enable = true;

     packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        comic-mono
     ];

     fontconfig = {
        antialias = true;
     };
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11"; 
}

