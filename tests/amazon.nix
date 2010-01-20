rec {

  machine =
    { config, pkgs, ... }:
    
    {
      services.httpd.enable = true;
      services.httpd.adminAddr = "e.dolstra@tudelft.nl";
      services.httpd.documentRoot = "${pkgs.valgrind}/share/doc/valgrind/html";

      nixpkgs.config.packageOverrides = pkgsOld:
        { dhcp = pkgs.lib.overrideDerivation pkgsOld.dhcp (oldAttrs:
            { configureFlags = "--disable-dhcpv6";
            });
        };

      fileSystems = [ ];

      swapDevices =
        [ { device = "/dev/sda2"; } ];

      services.sshd.enable = true;
      services.sshd.permitRootLogin = "without-password";

      services.mingetty.ttys = [ ];
    };

  config = (import ../lib/eval-config.nix {
    system = "i686-linux";
    modules = [ machine ../modules/virtualisation/amazon-image.nix ];
  }).config;

}
