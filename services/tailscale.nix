{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tailscale
  ];

  age.secrets.tailscale.file = "/home/homelab/homelab/secrets/tailscale.age";
  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--ssh" ];
    authKeyFile = config.age.secrets.tailscale.path;
  };
}
