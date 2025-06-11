{
  description = "NixOS in MicroVMs";

  inputs.microvm = {
    url = "github:astro/microvm.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      microvm,
    }:
    let
      system = "x86_64-linux";
    in
    {
      packages.${system} = {
        default = self.packages.${system}.melchior;
        melchior = self.nixosConfigurations.melchior.config.microvm.declaredRunner;
      };

      nixosConfigurations = {
        melchior = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            microvm.nixosModules.microvm
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
          ];
        };
      };
    };
}
