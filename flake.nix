{
  description = "A very basic flake";

  inputs = {
    # Monorepo for pks and software
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Manage hardware
    hardware.url = "github:nixos/nixos-hardware/master";
    # Minecraft server >:)
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs = inputs@{ self, nixpkgs, hardware, nix-minecraft }: {
    nixosConfigurations = {
      homelab = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./hosts/homelab
        ];
      };
    };
  };
}
