{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "step-cli";
  version = "0.13.3";

  goPackagePath = "github.com/smallstep/cli";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0b5hk9a8yq1nyh8m1gmf28yiha95xwsc4dk321g84hvai7g47pbr";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "A zero trust swiss army knife for working with X509, OAuth, JWT, OATH OTP, etc";
    homepage = "https://smallstep.com/cli/";
    license = licenses.asl20;
    maintainers = with maintainers; [ xfix ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
