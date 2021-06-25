{ lib, buildGoModule, fetchFromGitHub }:

let
  generic = { pname, packageToBuild, description }:
    buildGoModule rec {
      inherit pname;
      version = "0.2.0";

      src = fetchFromGitHub {
        owner = "sigstore";
        repo = "rekor";
        rev = "v${version}";
        sha256 = "1y6qw55r30jgkcwc6434ly0v9dcfa2lc7z5djn7rjcqrjg3gn7yv";
      };

      vendorSha256 = "1wlh505ypwyr91wi80fpbap3far3fljwjd4mql2qcqgg0b1yay9s";

      subPackages = [ packageToBuild ];

      preBuild = ''
        buildFlagsArray+=("-ldflags" "-s -w -X github.com/sigstore/rekor/${packageToBuild}/app.gitVersion=v${version}")
      '';

      meta = with lib; {
        inherit description;
        homepage = "https://github.com/sigstore/rekor";
        changelog = "https://github.com/sigstore/rekor/releases/tag/v${version}";
        license = licenses.asl20;
        maintainers = with maintainers; [ lesuisse ];
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
