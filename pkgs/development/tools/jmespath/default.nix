{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "jmespath-${version}";
  version = "0.2.2";
  rev = "${version}";

  goPackagePath = "github.com/jmespath/go-jmespath";

  src = fetchFromGitHub {
    inherit rev;
    owner = "jmespath";
    repo = "go-jmespath";
    sha256 = "0f4j0m44limnjd6q5fk152g6jq2a5cshcdms4p3a1br8pl9wp5fb";
  };
  meta = with stdenv.lib; {
    description = "A JMESPath implementation in Go";
    homepage = https://github.com/jmespath/go-jmespath;
    maintainers = with maintainers; [ cransom ];
    license = licenses.asl20;
  };
}
