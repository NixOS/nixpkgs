rec {

  machine =
    { config, pkgs, ... }:
    
    {
      services.httpd.enable = true;
      services.httpd.adminAddr = "e.dolstra@tudelft.nl";
      services.httpd.documentRoot = "${pkgs.valgrind}/share/doc/valgrind/html";
    };

  config = (import ../lib/eval-config.nix {
    system = "i686-linux";
    modules = [ machine ../modules/virtualisation/amazon-image.nix ];
  }).config;

}
