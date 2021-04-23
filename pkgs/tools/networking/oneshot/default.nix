{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "oneshot";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "raphaelreyna";
    repo = "oneshot";
    rev = "v${version}";
    sha256 = "sha256-UD67xYBb1rvGMSPurte5z2Hcd7+JtXDPbgp3BVBdLuk=";
  };

  vendorSha256 = "sha256-d+YE618OywSDOWiiULHENFEqzRmFVUFKPuPXnL1JubM=";

  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "A first-come-first-serve single-fire HTTP server";
    homepage = "https://github.com/raphaelreyna/oneshot";
    license = licenses.mit;
    maintainers = with maintainers; [ edibopp ];
  };
}
