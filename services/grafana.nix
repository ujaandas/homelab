{ config, pkgs, ... }: 
let
  tailscaleHostname = "homelab.rooster-kettle.ts.net"; 
in
{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        # Bind Grafana to localhost
        http_addr = "127.0.0.1";
        http_port = 3000;

        # Use the Tailscale hostname for domain and root_url
        domain = tailscaleHostname;
        root_url = "https://${tailscaleHostname}/";
      };
    };
  };

  # nginx reverse proxy
  services.nginx.virtualHosts."${tailscaleHostname}" = {
    addSSL = true;
    enableACME = true; # Tailscale handles HTTPS certificates
    locations."/" = {
      proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}