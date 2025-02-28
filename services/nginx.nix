{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    virtualHosts."homelab" = {
      locations."/grafana/" = {
        proxyPass = "http://localhost:3000/"; # Proxy to Grafana
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          rewrite  /grafana(/.*)  /$1 break;
          sub_filter '/public/' '/grafana/public/';
          sub_filter_once off;
        '';
      };
      locations."/jellyfin/" = {
        proxyPass = "http://localhost:8096/"; # Proxy to Jellyfin
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;

          # Ensure paths and assets work correctly with the /jellyfin subpath
          rewrite /jellyfin(/.*) $1 break;
          sub_filter '/web/' '/jellyfin/web/';
          sub_filter '/api/' '/jellyfin/api/';
          sub_filter_once off;
        '';
      };
    };
  };
}
