{ config, pkgs, ... }:

{
  imports =
    [
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
    vim
    wget
    git
    cowsay
    nil
    nixfmt-rfc-style
    nss_latest
  ];

  networking = {
    hostName = "homelab";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      allowedTCPPorts = [ 80 443 ];
    };

    wireguard.interfaces.wg0 = {
      generatePrivateKeyFile = true;
      privateKeyFile = "~/wg/wg0";
    };
  };

  users.users.homelab = {
    isNormalUser = true;
    description = "homelab";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.11";
}
