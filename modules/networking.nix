{ config, pkgs, ... }:

{
  networking = {
    hostName = "homelab";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts = [ ];
    };

    wireguard.interfaces.wg0 = {
      generatePrivateKeyFile = true;
      privateKeyFile = "~/wg/wg0";
    };
  };
}
