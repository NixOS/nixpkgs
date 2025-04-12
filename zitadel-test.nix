let
  nixpkgs = import ./. { system = "x86_64-linux"; };
  evalConfig = import (nixpkgs.path + "/nixos/lib/eval-config.nix");
in evalConfig {
  system = "x86_64-linux";
  modules = [
    ./nixos/modules/services/web-apps/zitadel.nix
    {
      services.zitadel = {
        enable = true;
        databaseName = "zitadel";
        databaseUser = "zitadel";
        databasePassword = "zitadel";
        masterKeyFile = "${./masterkey}";
        settings = { Port = 8080; };
      };
      services.postgresql.enable = true;
      networking.firewall.allowedTCPPorts = [ 8080 ];
      system.stateVersion = "25.05";
    }
  ];
}
