{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "cloud-nuke";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "054z6v13x55x9l5xnixxxszj8k2wa09b5ld2wq4gm4hc273s2m4k";
  };

  goPackagePath = "github.com/gruntwork-io/cloud-nuke";

  goDeps = ./deps.nix;

  meta = with lib; {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
