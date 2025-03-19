{ inputs, pkgs, lib, ... }:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      jooj = {
        enable = true;
        package = pkgs.paperServers.paper-1_21_4;

        # Server properties
        serverProperties = {
          "difficulty" = "normal"; # Options: peaceful, easy, normal, hard
          "gamemode" = "survival"; # Options: survival, creative, adventure, spectator
          "max-players" = 3; # Maximum number of players
          "motd" = "Happy 5th Anniversary Jessie!"; # Message of the Day
          "view-distance" = 8; # Reduce render distance
          "simulation-distance" = 8; # Reduce simulation distance
          "max-build-height" = 256; # Maximum build height
          "spawn-protection" = 16; # Spawn protection radius
          "online-mode" = true; # Whether to use online mode (auth with Mojang)
          "allow-flight" = false; # Whether to allow flying
          "entity-activation-range-animals" = 16; # Reduce activation range for animals
          "entity-activation-range-monsters" = 16; # Reduce activation range for monsters
          "entity-activation-range-misc" = 8; # Reduce activation range for other entities
        };
      };
    };
  };
}
