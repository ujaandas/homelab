{
  config,
  pkgs,
  ...
}:

{
  imports = [
    # supplement client apps
    ../../services/tailscale.nix
    ../../services/ssh.nix
    ../../services/prometheus.nix
    ../../services/caddy.nix
    # client facing
    ../../services/grafana.nix
    ../../services/minecraft.nix
    ../../services/jellyfin.nix
    ../../services/vaultwarden.nix
  ];

  time.timeZone = "Asia/Hong_Kong";
  i18n.defaultLocale = "en_HK.UTF-8";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    cowsay
    nil
    nixfmt-rfc-style
    nssTools
  ];

  networking = {
    hostName = "magi";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts = [
        80
        443
      ];
    };

   # wireguard.interfaces.wg0 = {
   #   generatePrivateKeyFile = true;
   #   privateKeyFile = "~/wg/wg0";
   # };
  };

  systemd.network = {
    enable = false;
    wait-online.enable = false;

    networks = {
      "10-lan" = {
        matchConfig.Name = [
          "eno1"
          "vm-*"
        ];
        networkConfig = {
          Bridge = "br0";
        };
      };

      "10-lan-bridge" = {
        matchConfig.Name = "br0";
        networkConfig = {
          Address = [
            "192.168.1.2/24"
            "2001:db8::a/64"
          ];
          Gateway = "192.168.1.1";
          DNS = [ "192.168.1.1" ];
          IPv6AcceptRA = true;
        };
        linkConfig.RequiredForOnline = "routable";
      };
    };

    netdevs = {
      "br0" = {
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
        };
      };
    };
  };

  users.users.admin = {
    isNormalUser = true;
    description = "admin";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
  };

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.11";
}
