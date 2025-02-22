{ config, pkgs, ... }:

{
  users.users.homelab = {
    isNormalUser = true;
    description = "homelab";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
}
