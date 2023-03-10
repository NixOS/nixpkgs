{ buildGoModule, fetchFromGitHub, lib, symlinkJoin }:
let
  generic = { modRoot, vendorSha256 }:
    buildGoModule rec {
      pname = "bird-lg-${modRoot}";
      version = "unstable-2022-05-08";

      src = fetchFromGitHub {
        owner = "xddxdd";
        repo = "bird-lg-go";
        rev = "348295b9aa954a92df2cf6b1179846a9486dafc0";
        sha256 = "sha256-2t8ZP9Uc0sJlqWiJMq3MVoARfMKsuTXJkuOid0oWgyY=";
      };

      doDist = false;

      ldflags = [
        "-s"
        "-w"
      ];

      inherit modRoot vendorSha256;

      meta = with lib; {
        description = "Bird Looking Glass";
        homepage = "https://github.com/xddxdd/bird-lg-go";
        license = licenses.gpl3Plus;
        maintainers = with maintainers; [ tchekda ];
      };
    };

  bird-lg-frontend = generic {
    modRoot = "frontend";
    vendorSha256 = "sha256-WKuVGiSV5LZrJ8/672TRN6tZNQxdCktHV6nx0ZxCP4A=";
  };

  bird-lg-proxy = generic {
    modRoot = "proxy";
    vendorSha256 = "sha256-7LZeCY4xSxREsQ+Dc2XSpu2ZI8CLE0mz0yoThP7/OO4=";
  };
in
symlinkJoin { name = "bird-lg"; paths = [ bird-lg-frontend bird-lg-proxy ]; }
