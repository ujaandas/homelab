{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;
  networking.hostName = "homelab";

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    allowedTCPPorts = [  ];
  };

  networking.wireguard.interfaces.wg0 = {
    generatePrivateKeyFile = true;
    privateKeyFile = "~/wg/wg0";
  };
}
