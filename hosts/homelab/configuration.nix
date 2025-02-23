{ config, pkgs, ... }:

{
  imports =
    [
      ../../modules/networking.nix
      ../../modules/i18n.nix
      ../../modules/user.nix
      ../../services/tailscale.nix
      ../../services/ssh.nix
      ../../services/grafana.nix
      ../../services/prometheus.nix
      ../../apps/minecraft.nix
      ../../apps/jellyfin.nix
    ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    cowsay
    nixfmt-rfc-style
  ];

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.11";
}
