{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "open-policy-agent";
  version = "0.22.0";

  goPackagePath = "github.com/open-policy-agent/opa";
  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "opa";
    rev = "v${version}";
    sha256 = "1kndiiqf6b4j8zhv0ypjr9dfjgck25qiqa2bb0pmpm3j9460zzjs";
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
