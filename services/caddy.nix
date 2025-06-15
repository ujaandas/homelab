{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "magi.hl".extraConfig = ''
        tls internal
        reverse_proxy 127.0.0.1:8000
      '';
    };
    # virtualHosts."homelab".extraConfig = ''
    #   tls internal

    #   handle_path /grafana/* {
    #     reverse_proxy localhost:3000 {
    #       header_up Host {host}
    #       header_up X-Real-IP {remote}
    #     }
    #   }

    #   handle_path /jellyfin/* {
    #     reverse_proxy localhost:8096 {
    #       header_up Host {host}
    #       header_up X-Real-IP {remote}
    #     }
    #   }

    #   reverse_proxy localhost:8222 {
    #     header_up Host {host}
    #       header_up X-Real-IP {remote
    #     }
    # '';
  };
}
