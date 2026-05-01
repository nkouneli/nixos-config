{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];
  nixpkgs.config.permittedInsecurePackages = [
     "dotnet-runtime-6.0.36"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=dell-headset-multi
  '';

  environment.sessionVariables = {
     DOTNET_ROLL_FORWARD_ON_NO_CANDIDATE_FX=2;
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
     windowManager.qtile.enable = true;
  };
  services.displayManager.ly.enable = true;
  services.blueman.enable = true;

  services.printing.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;

  services.thermald.enable = true;
  services.tlp.enable = true;

  services.mysql = {
    enable = true;
    package = pkgs.mysql-workbench;
   };

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
    extraGroups = [ "wheel" "video" "libvirtd" ];
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

  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    alacritty
    easyeffects
    dotnet-sdk
    dotnet-runtime_6
    git
    protonup-qt
    pcmanfm
    pwvucontrol
    vim 
    wget
    xclip
    maim
    xev
    kdePackages.wacomtablet
    libwacom
    zip
    unzip
    usbutils
    udiskie
    udisks
    image-roll
    btop
    alsa-utils
    libvirt
    alsa-tools
    pavucontrol
    pulseaudio
    steam-run
    appimage-run
    baobab
    wineWow64Packages.stable
    lutris
  ];

  fonts = {
     enableDefaultPackages = true;
     fontDir.enable = true;

     packages = with pkgs; [
        nerd-fonts.jetbrains-mono
     ];

     fontconfig = {
        antialias = true;
     };
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11"; 
}

