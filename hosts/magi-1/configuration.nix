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
    useNetworkd = true;

    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts = [
        22
        80
        443
      ];
    };
  };

  systemd.network = {
    enable = true; # already enabled by networking.useNetworkd
    wait-online.enable = false;

    networks = {
      "10-eno1" = {
        matchConfig.Name = "eno1";
        networkConfig = {
          DHCP = "ipv4";
        };
      };

      "10-microvm" = {
        matchConfig.Name = "microvm";
        networkConfig = {
          Address = [
            "10.0.0.1/24"
            "fd12:3456:789a::1/64"
          ];
          DHCPServer = true;
          IPv6AcceptRA = true;
        };
      };

      "20-microvm" = {
        matchConfig.Name = "vm-*";
        networkConfig = {
          Bridge = "microvm";
        };
      };
    };

    netdevs = {
      "microvms" = {
        netdevConfig = {
          Name = "microvm";
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
