{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      nixos-dotfiles/hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Belgrade";

  services.xserver = {
     enable = true;
     xkb.layout = "ba";
     autoRepeatDelay = 200;
     autoRepeatInterval = 35;
     windowManager.qtile.enable = true;
  };
  services.displayManager.ly.enable = true;

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users.nyx = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    alacritty
    git
    vim 
    wget
  ];

  fonts.packages = with pkgs; [
     nerd-fonts.jetbrains-mono
  ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11"; 
}

