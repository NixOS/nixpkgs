{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "s3gof3r";
  version = "0.5.0";

  goPackagePath = "github.com/rlmcpherson/s3gof3r";

  src = fetchFromGitHub {
    owner = "rlmcpherson";
    repo = "s3gof3r";
    rev = "v${version}";
    sha256 = "sha256-88C6c4DRD/4ePTO1+1YiI8ApXWE2uUlr07dDCxGzaoE=";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Fast, concurrent, streaming access to Amazon S3, including gof3r, a CLI";
    homepage = "https://pkg.go.dev/github.com/rlmcpherson/s3gof3r";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
