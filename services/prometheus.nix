{ config, pkgs, ... }:
{
  services.prometheus = {
    enable = true;
    port = 9001;
    globalConfig.scrape_interval = "15s";
    exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [
        "systemd"
      ];
    };
    scrapeConfigs = 
    [
      {
        job_name = "node";
        static_configs = [{
          targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
    ];
  };
}

