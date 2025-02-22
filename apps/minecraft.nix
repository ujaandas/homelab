{ inputs, pkgs, ... }:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      jess-n-ooj = {
        enable = true;
        package = pkgs.paperServers.paper-1_21_4;
      };
    };
  };
}