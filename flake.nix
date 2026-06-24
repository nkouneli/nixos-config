{
   description = "my super cool nixos !!!!!";
   inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

   inputs = {
      nixpkgs.url = "nixpkgs/nixos-26.05";

      home-manager = {
         url = "github:nix-community/home-manager/release-26.05";
	      inputs.nixpkgs.follows = "nixpkgs";
      };

      nixos-06cb-009a-fingerprint-sensor = {
         url = "github:iedame/nixos-06cb-009a-fingerprint-sensor?ref=25.11";
         inputs.nixpkgs.follows = "nixpkgs";
      };
   };

   outputs = { self, nixpkgs, home-manager, nixos-hardware, nixos-06cb-009a-fingerprint-sensor, ... }: {
      nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {   
         system = "x86_64-linux";
	      modules = [
            ./configuration.nix
            nixos-hardware.nixosModules.lenovo-thinkpad-x280
            nixos-06cb-009a-fingerprint-sensor.nixosModules."06cb-009a-fingerprint-sensor"
	         home-manager.nixosModules.home-manager
	         {
		         home-manager = {
                  useGlobalPkgs = true;
	               useUserPackages = true;
	               users.nyx = import ./home.nix;
	               backupFileExtension = "backup";
	            };
	         }
	      ];
      };
   };
}
