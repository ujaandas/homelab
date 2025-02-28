{
  description = "A very basic flake";

  inputs = {
    # Monorepo for pks and software
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Manage hardware
    hardware.url = "github:nixos/nixos-hardware/master";
    # Manage secrets
    agenix.url = "github:ryantm/agenix";
    # Minecraft server >:)
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs = inputs@{ self, nixpkgs, hardware, agenix, nix-minecraft }: {
    nixosConfigurations = {
      homelab = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./hosts/homelab
          agenix.nixosModules.default
        ];
      };
    };
  };
}
