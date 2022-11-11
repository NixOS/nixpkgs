{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "upbound";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = "up";
    rev = "v${version}";
    sha256 = "sha256-tbYUxqDtMIlHJ+bIE9PDDhPTSQKaZYObuRFSyRkh8+Y=";
  };

  vendorSha256 = "sha256-EeGNH/ka9Mt0vVtZfizXdTqf1f3H1aM5GITUyp+2FxM=";

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
