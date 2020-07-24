{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "cloud-nuke";
  version = "0.1.18";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "1amk9bjrc9svvgllif2vr6xx7kc3xmwjbyb8prnm5zp82hymk5f1";
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
