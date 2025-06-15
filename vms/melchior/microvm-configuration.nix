{ ... }:
{
  microvm = {
    mem = 1024;
    vcpu = 1;

    interfaces = [
      {
        type = "tap";
        id = "vm-melchior";
        mac = "02:00:00:00:00:01";
      }
    ];

    volumes = [
      {
        mountPoint = "/";
        image = "root.img";
        size = 512;
      }
    ];

    shares = [
      {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
    ];
  };
}
