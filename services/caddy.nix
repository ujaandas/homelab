{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."homelab".extraConfig = ''
      tls internal

      # --- Grafana Reverse Proxy ---
      handle_path /grafana/* {
        rewrite * /grafana/{uri}
        reverse_proxy http://localhost:3000 {
          header_up Host {host}
          header_up X-Real-IP {remote}
          header_up X-Forwarded-For {remote}
          header_up X-Forwarded-Proto {scheme}
        }
      }

      # --- Jellyfin Reverse Proxy ---
      handle_path /jellyfin/* {
        rewrite * /jellyfin/{path}
        reverse_proxy http://localhost:8096 {
          header_up Host {host}
          header_up X-Real-IP {remote}
          header_up X-Forwarded-For {remote}
          header_up X-Forwarded-Proto {scheme}
        }
      }
    '';
  };
}
