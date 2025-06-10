{ config, pkgs, ... }:
let
  tailscaleHostname = "homelab";
in
{
  services.grafana = {
    enable = true;
    settings = {
      analytics.reporting_enabled = false;
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;

        domain = tailscaleHostname;
        root_url = "/grafana/";
      };
    };
    provision = {
      enable = true;

      # Provision dashboards
      dashboards.settings.providers = [
        {
          name = "my dashboards";
          options.path = "/etc/grafana-dashboards";
        }
      ];

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
  environment.etc."grafana-dashboards/node-exporter-full.json".text =
    builtins.readFile ../resources/node-exporter-full.json;
}
