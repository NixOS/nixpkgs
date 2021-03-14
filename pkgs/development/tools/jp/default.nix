{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "jp";
  version = "0.1.3";
  rev = version;

  goPackagePath = "github.com/jmespath/jp";

  src = fetchFromGitHub {
    inherit rev;
    owner = "jmespath";
    repo = "jp";
    sha256 = "0fdbnihbd0kq56am3bmh2zrfk4fqjslcbm48malbgmpqw3a5nvpi";
  };
  meta = with lib; {
    description = "A command line interface to the JMESPath expression language for JSON";
    homepage = "https://github.com/jmespath/jp";
    maintainers = with maintainers; [ cransom ];
    license = licenses.asl20;
  };
}
