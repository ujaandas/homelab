{ config, pkgs, ... }: 
let
  tailscaleHostname = "homelab.rooster-kettle.ts.net"; 
in
{
  services.grafana = {
    enable = true;
    settings = {
      analytics.reporting_enabled = false;
      server = {
        # Bind Grafana to localhost
        http_addr = "0.0.0.0";
        http_port = 3000;

        # Use the Tailscale hostname for domain and root_url
        domain = tailscaleHostname;
        root_url = "https://${tailscaleHostname}/";
      };
    };
    provision = {
      enable = true;

      # Provision dashboards
      dashboards.settings.providers = [{
        name = "my dashboards";
        options.path = "/etc/grafana-dashboards";
      }];

      # Provision datasources
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
        }
      ];
    };
  };

  # Deploy the Node Exporter Full dashboard JSON
  environment.etc."grafana-dashboards/node-exporter-full.json".text = builtins.readFile ../resources/node-exporter-full.json;
}