{ ... }:
{
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "tailscale0";
      address = [
        "/magi.hl/100.74.77.52"
        "/melchior.magi.hl/100.74.77.52"
      ];
      bind-interfaces = true;
    };
  };
  services.resolved.enable = true;
}
