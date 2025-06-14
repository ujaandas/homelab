{
  description = "Melchior VM configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    microvm.url = "github:astro/microvm.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      microvm,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.melchior = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          microvm.nixosModules.microvm
          ./default.nix
        ];
        specialArgs = { inherit self nixpkgs microvm; };
      };
    };
}
