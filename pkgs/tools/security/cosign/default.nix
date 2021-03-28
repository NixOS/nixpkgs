{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cosign";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rgq29vi0h378j0bqs53gjgp246rqxfpk6rwskzrmawgry0zr8pk";
  };

  vendorSha256 = "0pcp3wdvwq06ajdfbgadyq0ipfj65n276hj88p5v6wqfn821ahd6";

  subPackages = [ "cmd/cosign" ];

  meta = with lib; {
    homepage = "https://github.com/sigstore/cosign";
    changelog = "https://github.com/sigstore/cosign/releases/tag/v${version}";
    description = "Container Signing CLI with support for ephemeral keys and Sigstore signing";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse ];
  };
}
