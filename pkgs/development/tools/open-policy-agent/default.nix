{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "open-policy-agent";
  version = "0.24.0";

  goPackagePath = "github.com/open-policy-agent/opa";
  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "opa";
    rev = "v${version}";
    sha256 = "0fv2rq8a01hapcpgfqp71v113iyyzs5w1sam14h9clyr1vqrbcf2";
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
