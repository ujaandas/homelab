{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    openFirewall = false;
    hostKeys = [
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/home/homelab/.ssh/id_ed25519";
        type = "ed25519";
      }
    ];
  };
  programs.ssh.startAgent = true;
}
