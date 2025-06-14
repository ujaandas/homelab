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

    melchior = {
      url = "path:./vms/melchior";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.microvm.follows = "microvm";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      hardware,
      agenix,
      nix-minecraft,
      microvm,
      melchior,
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
            {
              microvm = {
                autostart = [
                  "melchior"
                ];
                vms = {
                  melchior = {
                    flake = melchior;
                    updateFlake = "file://${toString ./vms/melchior}";
                  };
                };
              };
            }
          ];
        };
      };
    };
}
