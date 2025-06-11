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
    # Microvm
    microvm.url = "github:astro/microvm.nix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      hardware,
      agenix,
      nix-minecraft,
      microvm,
    }:
    {
      nixosConfigurations = {
        magi = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit self inputs; };
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.default
            microvm.nixosModules.host
            ./hosts/magi-1
          ];
        };
      };
    };
}
