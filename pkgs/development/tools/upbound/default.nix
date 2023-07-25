{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "upbound";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "up";
    rev = "v${version}";
    sha256 = "sha256-kpk54P9+ITBdlytwxfAhVNTkJN8SReFXgjUdWXclr1I=";
  };

  vendorHash = "sha256-aqKLWd7C7LLIZm5jSksqp35zWNSYSzTZ8gGHUgWgq9E=";

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
