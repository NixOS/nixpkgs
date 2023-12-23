{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "terrapin-scanner-${version}";
  version = "1.1.0";

  vendorHash = "sha256-skYMlL9SbBoC89tFCTIzyRViEJaviXENASEqr6zSvoo=";

  src = fetchFromGitHub{
    owner = "RUB-NDS";
    repo = "Terrapin-Scanner";
    rev = "v${version}";
    sha256 = "d0aAs9dT74YQkzDQnmeEo+p/RnPHeG2+SgCCF/t1F+w=";
  };

  buildPhase = ''
    go install
  '';

  meta = with lib; {
    description = "This tool can be used to determine the vulnerability of an SSH client or server against the Terrapin Attack..";
    homepage = https://github.com/RUB-NDS/Terrapin-Scanner;
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
