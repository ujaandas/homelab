{ pkgs, ...}: {
  networking.wg-quick.interfaces = 
  let
    server_ip = "18.19.23.66";
  in
  {
    wg0 = {
      address 
    };
  };
}
