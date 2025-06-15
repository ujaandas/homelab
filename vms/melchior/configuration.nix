{ ... }:
{
  networking = {
    hostName = "melchior";
    useNetworkd = true;
    firewall.allowedTCPPorts = [ 22 ];
  };

  systemd.network = {
    enable = true;
    networks."20-lan" = {
      matchConfig.Type = "ether";
      networkConfig = {
        Address = [
          "10.0.0.10/24"
          "fd12:3456:789a::10/64"
        ];
        Gateway = "10.0.0.1";
        DNS = [
          "10.0.0.1"
          "8.8.8.8"
        ];
        IPv6AcceptRA = false;
        DHCP = "no";
      };
    };
  };

  users.users.default = {
    initialPassword = "password";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  services.openssh.enable = true;

  system.stateVersion = "24.11";
}
