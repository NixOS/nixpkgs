{ lib, buildGoModule, fetchFromGitHub, stdenv }:

buildGoModule rec {
  pname = "gitsign";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0cu5uJVFiqkvfVxCbrruHLa4Zj0EU75cbgrTrwzo7+U=";
  };
  vendorSha256 = "sha256-JMS/OFL2oxQFWa+wNhxS7fXSYQbCSEV3Sakq4rmsolI=";

  ldflags = [ "-s" "-w" "-buildid=" "-X github.com/sigstore/gitsign/pkg/version.gitVersion=${version}" ];

  meta = {
    homepage = "https://github.com/sigstore/gitsign";
    changelog = "https://github.com/sigstore/gitsign/releases/tag/v${version}";
    description = "Keyless Git signing using Sigstore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lesuisse ];
  };
}
