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

                firewall.allowedTCPPorts = [
                  22
                ];
              };

              users.users.default = {
                initialPassword = "password";
                isNormalUser = true;
                extraGroups = [ "wheel" ];
              };

              systemd.network = {
                enable = true;

                networks."20-lan" = {
                  matchConfig.Type = "ether";
                  networkConfig = {
                    Address = [
                      "192.168.1.3/24"
                      "2001:db8::b/64"
                    ];
                    Gateway = "192.168.1.1";
                    DNS = [ "192.168.1.1" ];
                    IPv6AcceptRA = true;
                    DHCP = "no";
                  };
                };
              };

              services.openssh.enable = true;

              system.stateVersion = "24.11";

              microvm = {
                mem = 1024;
                vcpu = 1;

                interfaces = [
                  {
                    type = "tap";
                    id = "vm-test1";
                    mac = "02:00:00:00:00:01";
                  }
                ];

                volumes = [
                  {
                    # Preserve root of vm
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
