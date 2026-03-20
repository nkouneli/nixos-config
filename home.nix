{ config, pkgs, ... }:
let
   dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
   create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
   configs = {
      qtile = "qtile";
      nvim = "nvim";
   };
in
{
   home.username = "nyx";
   home.homeDirectory = "/home/nyx";
   home.stateVersion = "25.11";
   
   xdg.configFile = builtins.mapAttrs 
     (name: subpath: {
        source = create_symlink "${dotfiles}/${subpath}";
        recursive = true;
     })
     configs;

   home.packages = with pkgs; [
      neovim
      ripgrep
      nil
      nixpkgs-fmt
      nodejs
      gcc
      discord
   ];

   programs.git.enable = true;
   programs.bash = {
      enable = true;
      shellAliases = {
         bnuuy = "echo bnuuuyyy !!!!!!!";
      };
   };
}
