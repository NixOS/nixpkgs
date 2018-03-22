{ stdenv, lib, buildGoPackage, fetchFromGitHub, jmespath }:

buildGoPackage rec {
  name = "jp-${version}";
  version = "0.1.2";
  rev = "${version}";

  goPackagePath = "github.com/jmespath/jp";

  src = fetchFromGitHub {
    inherit rev;
    owner = "jmespath";
    repo = "jp";
    sha256 = "1i0jl0c062crigkxqx8zpyqliz8j4d37y95cna33jl777kx42r6h";
  };
  meta = with stdenv.lib; {
    description = "A command line interface to the JMESPath expression language for JSON";
    homepage = https://github.com/jmespath/jp;
    maintainers = with maintainers; [ cransom ];
    license = licenses.asl20;
  };
}
