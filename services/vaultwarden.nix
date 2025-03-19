{ config, pkgs, ... }: 
{
  age.secrets.vaultwarden.file = ../secrets/vaultwarden.age;
  services.vaultwarden = {
    enable = true;
    backupDir = "/var/backup/vaultwarden";
    environmentFile = config.age.secrets.vaultwarden.path;
    config = {
      DOMAIN = "http://homelab";
      SIGNUPS_ALLOWED = true;

      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;

      ROCKET_LOG = "critical";
    };
  };
}