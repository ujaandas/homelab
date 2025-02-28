let
  # define all systems/users
  homelab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINDTlKSSqN1AoEYqvt2ltCQLQj/gzqsdzNS0IyjiDPlv root@nixos";
  ooj = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKfdLPkNWm8bdQWbifTiHcizI0L2Zzo+ueDVbX/Kfp0S ujaandas03@gmail.com";
  systems = [ homelab ];
  users = [ ooj ];
in 
{
  # define which systems/users are able to decrypt which files
  "tailscale.age".publicKeys = users ++ systems;
}

# nix run github:ryantm/agenix -- <COMMAND>
# ie; agenix -e secret.age to edit (looks in ~/.ssh/ by default, specify location with -i <LOCATION>)