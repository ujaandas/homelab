{
  description = "A very basic flake";

  inputs = {
    # Monorepo for pks and software
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Manage hardware
    hardware.url = "github:nixos/nixos-hardware/master";
  };

  outputs = inputs@{ self, nixpkgs, hardware }: {
    nixosConfigurations = {
      homelab = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
	  ./hosts/homelab
	];
      };
    };
  };
}
