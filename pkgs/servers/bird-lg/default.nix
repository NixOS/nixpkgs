{ buildGoModule, fetchFromGitHub, lib, symlinkJoin }:
let
  generic = { modRoot, vendorHash }:
    buildGoModule rec {
      pname = "bird-lg-${modRoot}";
      version = "1.3.5";

      src = fetchFromGitHub {
        owner = "xddxdd";
        repo = "bird-lg-go";
        rev = "v${version}";
        hash = "sha256-lWpTIuN+wCSDBHmpRIfVG8Z1Qx1s55MnJomQPjczB5k=";
      };

      doDist = false;

      ldflags = [
        "-s"
        "-w"
      ];

      inherit modRoot vendorHash;

      meta = with lib; {
        description = "Bird Looking Glass";
        homepage = "https://github.com/xddxdd/bird-lg-go";
        changelog = "https://github.com/xddxdd/bird-lg-go/releases/tag/v${version}";
        license = licenses.gpl3Plus;
        maintainers = with maintainers; [
          tchekda
          e1mo
        ];
      };
    };

  bird-lg-frontend = generic {
    modRoot = "frontend";
    vendorHash = "sha256-+M9Mlqck2E/ETW+NXsKwIeWlmZAaBU07fgDhKUU9PAI=";
  };

  bird-lg-proxy = generic {
    modRoot = "proxy";
    vendorHash = "sha256-nBTLQUX68f98D0RTlyX0gnvhQ+bu8d3Vv67J/YoXJxs=";
  };
in
symlinkJoin {
  name = "bird-lg-${bird-lg-frontend.version}";
  paths = [ bird-lg-frontend bird-lg-proxy ];
} // {
  inherit (bird-lg-frontend) version meta;
}
