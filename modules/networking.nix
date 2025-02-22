{ config, pkgs, ... }:

{
  networking = {
    hostName = "homelab";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts = [ 
        3000  # grafana
        9090  # prometheus
      ];
    };

    wireguard.interfaces.wg0 = {
      generatePrivateKeyFile = true;
      privateKeyFile = "~/wg/wg0";
    };
  };
}
