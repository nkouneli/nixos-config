{ config, lib, pkgs, ... }:
let
   dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
   create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
   configs = {
      qtile = "qtile";
      nvim = "nvim";
   };
   shellAliases = {
      v = "nvim";
      vdiff = "nvim -d";
      bnuuy = "echo bnuuuyyyy!!!!!";
   };
in
{
   home.username = "nyx";
   home.homeDirectory = "/home/nyx";
   home.stateVersion = "25.11";
   
   home.shellAliases = shellAliases;
   
   xdg.configFile = builtins.mapAttrs 
     (name: subpath: {
        source = create_symlink "${dotfiles}/${subpath}";
        recursive = true;
     })
     configs;

   home.packages = with pkgs; [
      discord
      spotify
      krita
      aseprite
      vscode-fhs
      godot
      obs-studio
   ];

   programs.git.enable = true;
   programs.bash = {
      enable = true;
      shellAliases = shellAliases;
   };
   programs.neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      plugins = [
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      ];

      extraWrapperArgs = with pkgs; [
        "--suffix"
        "LIBRARY_PATH"
        ":"
        "${lib.makeLibraryPath [
          stdenv.cc.cc
          zlib
        ]}"

        "--suffix"
        "PKG_CONFIG_PATH"
        ":"
        "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
          stdenv.cc.cc
          zlib
        ]}"
      ];
    };
}
