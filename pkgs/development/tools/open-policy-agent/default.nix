{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "open-policy-agent";
  version = "0.15.0";

  goPackagePath = "github.com/open-policy-agent/opa";
  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "opa";
    rev = "v${version}";
    sha256 = "0i9735v73a7wfq02p4hsy61g7d7bip6zmb8bnsiz2ma84g2g533w";
  };
  goDeps = ./deps.nix;

  buildFlagsArray = ''
    -ldflags=
      -X ${goPackagePath}/version.Version=${version}
  '';

  meta = with lib; {
    description = "General-purpose policy engine";
    homepage = "https://www.openpolicyagent.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ lewo ];
    platforms = platforms.all;
  };
}
