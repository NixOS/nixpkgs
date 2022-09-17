{ lib, buildGoModule, fetchFromGitHub, stdenv }:

buildGoModule rec {
  pname = "gitsign";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ldVBaKBa9Rq15OXb0nAqY70RH5Ww9DRNmKZ5spuBOzc=";
  };
  vendorSha256 = "sha256-hE+P6dS/tC+y9Pf5IGy23a5j7VSDvedzcNTkLK4soiA=";

  ldflags = [ "-s" "-w" "-buildid=" "-X github.com/sigstore/gitsign/pkg/version.gitVersion=${version}" ];

  meta = {
    homepage = "https://github.com/sigstore/gitsign";
    changelog = "https://github.com/sigstore/gitsign/releases/tag/v${version}";
    description = "Keyless Git signing using Sigstore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lesuisse ];
  };
}
