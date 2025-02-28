{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  services.jellyfin = {
    enable = true;
    # TODO: Figure out configDir option to NOT yeet jellyfin publicly, only on localhost
    # and then require reverse proxy via nginx
  };

  # Create media directories and set permissions
  systemd.tmpfiles.rules = [
    "d /mnt/media 0755 jellyfin jellyfin - -"
    "d /mnt/media/movies 0755 jellyfin jellyfin - -"
    "d /mnt/media/tv_shows 0755 jellyfin jellyfin - -"
    "d /mnt/media/music 0755 jellyfin jellyfin - -"
  ];
}
