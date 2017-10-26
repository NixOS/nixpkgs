{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "textql-${version}";
  version = "2.0.3";
  rev = "${version}";

  goPackagePath = "github.com/dinedal/textql";

  src = fetchFromGitHub {
    inherit rev;
    owner = "dinedal";
    repo = "textql";
    sha256 = "1b61w4pc5gl7m12mphricihzq7ifnzwn0yyw3ypv0d0fj26h5hc3";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Execute SQL against structured text like CSV or TSV";
    homepage = https://github.com/dinedal/textql;
    license = licenses.mit;
    maintainers = with maintainers; [ vrthra ];
  };
}
