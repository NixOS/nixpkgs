{ lib, buildGoModule, fetchFromGitHub, stdenv }:

buildGoModule rec {
  pname = "gitsign";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jL39U7kmdy5lo/caetpFlFCLfby6ftMWDMPq6yt3nUk=";
  };
  vendorSha256 = "sha256-9tmENlR3vVELmT7JWcz7RhtIji7go2V/Bsu9nMrvHfs=";

  ldflags = [ "-s" "-w" "-buildid=" "-X github.com/sigstore/gitsign/pkg/version.gitVersion=${version}" ];

  meta = {
    homepage = "https://github.com/sigstore/gitsign";
    changelog = "https://github.com/sigstore/gitsign/releases/tag/v${version}";
    description = "Keyless Git signing using Sigstore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lesuisse ];
  };
}
