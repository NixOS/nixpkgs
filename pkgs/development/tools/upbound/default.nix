{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "upbound";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "up";
    rev = "v${version}";
    sha256 = "sha256-WUMFWI3SzpgQgf6txOOIVTK/gTp9h5w/iQUkwyxVbKA=";
  };

  vendorHash = "sha256-FDwcsf69l8GcMet9zUG2fuyoZgpEujB3A59eWg2GbdI=";

  subPackages = [ "cmd/docker-credential-up" "cmd/up" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/upbound/up/internal/version.version=v${version}"
  ];

  meta = with lib; {
    description =
      "CLI for interacting with Upbound Cloud, Upbound Enterprise, and Universal Crossplane (UXP)";
    homepage = "https://upbound.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
    mainProgram = "up";
  };
}
