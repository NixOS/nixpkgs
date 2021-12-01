{ lib, buildGoModule, fetchFromGitHub }:

let
  generic = { pname, packageToBuild, description }:
    buildGoModule rec {
      inherit pname;
      version = "0.3.0";

      src = fetchFromGitHub {
        owner = "sigstore";
        repo = "rekor";
        rev = "v${version}";
        sha256 = "sha256-FaVZm9C1pewJCZlYgNyD/ZYr/UIRvhqVTUhFTmysxeg=";
      };

      vendorSha256 = "sha256-EBKj/+ruE88qvlbOme4GBfAqt3/1jHcqhY0IHxh6Y5U=";

      subPackages = [ packageToBuild ];

      ldflags = [ "-s" "-w" "-X github.com/sigstore/rekor/${packageToBuild}/app.gitVersion=v${version}" ];

      meta = with lib; {
        inherit description;
        homepage = "https://github.com/sigstore/rekor";
        changelog = "https://github.com/sigstore/rekor/releases/tag/v${version}";
        license = licenses.asl20;
        maintainers = with maintainers; [ lesuisse jk ];
      };
    };
in {
  rekor-cli = generic {
    pname = "rekor-cli";
    packageToBuild = "cmd/rekor-cli";
    description = "CLI client for Sigstore, the Signature Transparency Log";
  };
  rekor-server = generic {
    pname = "rekor-server";
    packageToBuild = "cmd/rekor-server";
    description = "Sigstore server, the Signature Transparency Log";
  };
}
