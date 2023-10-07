{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "upbound";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "up";
    rev = "v${version}";
    sha256 = "sha256-Dr6EKpKVy2DLhivJ42Bx+WJL2L710sQlXroaAm66Gpo=";
  };

  vendorHash = "sha256-J7rZAvEx0jgkhJIEE19rV2WdBCIvkqYzB72ZiABs56U=";

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
