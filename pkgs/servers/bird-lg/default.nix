{ buildGoModule, fetchFromGitHub, lib, symlinkJoin }:
let
  generic = { modRoot, vendorSha256 }:
    buildGoModule rec {
      pname = "bird-lg-${modRoot}";
      version = "1.3.0";

      src = fetchFromGitHub {
        owner = "xddxdd";
        repo = "bird-lg-go";
        rev = "v${version}";
        hash = "sha256-VQJHrC9ag697QfCEre1KvwbotfMm8f1otJ6SPg5zRYM=";
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
    vendorSha256 = "sha256-4ajQp425SFciTi2DV3ITW4iQkq6kUJFK2BabTTb87Zo=";
  };

  bird-lg-proxy = generic {
    modRoot = "proxy";
    vendorSha256 = "sha256-o8F3uNGpz1fZr15HCY2PC7xRx9NakmvYrVQKe42ElOA=";
  };
in
symlinkJoin {
  name = "bird-lg-${bird-lg-frontend.version}";
  paths = [ bird-lg-frontend bird-lg-proxy ];
} // {
  inherit (bird-lg-frontend) version meta;
}
