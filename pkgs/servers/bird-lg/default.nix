{ buildGoModule, fetchFromGitHub, lib, symlinkJoin }:
let
  generic = { modRoot, vendorSha256 }:
    buildGoModule rec {
      pname = "bird-lg-${modRoot}";
      version = "1.2.0";

      src = fetchFromGitHub {
        owner = "xddxdd";
        repo = "bird-lg-go";
        rev = "v${version}";
        sha256 = "sha256-Ldp/c1UU5EFnKjlUqQ+Hh6rVEOYEX7kaDL36edr9pNA=";
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
        changelog = "https://github.com/xddxdd/bird-lg-go/releases/tag/v${version}";
        license = licenses.gpl3Plus;
        maintainers = with maintainers; [ tchekda ];
      };
    };

  bird-lg-frontend = generic {
    modRoot = "frontend";
    vendorSha256 = "sha256-lYOi3tfXYhsFaWgikDUoJYRm8sxFNFKiFQMlVx/8AkA=";
  };

  bird-lg-proxy = generic {
    modRoot = "proxy";
    vendorSha256 = "sha256-QHLq4RuQaCMjefs7Vl7zSVgjLMDXvIZcM8d6/B5ECZc=";
  };
in
symlinkJoin {
  name = "bird-lg-${bird-lg-frontend.version}";
  paths = [ bird-lg-frontend bird-lg-proxy ];
} // {
  inherit (bird-lg-frontend) version meta;
}
