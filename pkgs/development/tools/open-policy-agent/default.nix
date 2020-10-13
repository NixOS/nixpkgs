{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "open-policy-agent";
  version = "0.23.2";

  goPackagePath = "github.com/open-policy-agent/opa";
  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "opa";
    rev = "v${version}";
    sha256 = "18hpanfrzg6xnq1g0yws6g0lw4y191pnrqphccv13j6kqk3k10ps";
  };

  subPackages = [ "." ];

  buildFlagsArray = ''
    -ldflags=
      -X ${goPackagePath}/version.Version=${version}
  '';

  meta = with lib; {
    description = "General-purpose policy engine";
    homepage = "https://www.openpolicyagent.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ lewo ];
  };
}
