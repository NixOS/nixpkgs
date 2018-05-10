{ stdenv, lib, buildGoPackage, fetchFromGitHub, sqlite }:

buildGoPackage rec {
  name = "textql-${version}";
  version = "2.0.3";

  goPackagePath = "github.com/dinedal/textql";

  src = fetchFromGitHub {
    owner  = "dinedal";
    repo   = "textql";
    rev    = version;
    sha256 = "1b61w4pc5gl7m12mphricihzq7ifnzwn0yyw3ypv0d0fj26h5hc3";
  };

  postInstall = ''
    install -Dm644 -t $out/share/man/man1 ${src}/man/textql.1
  '';

  # needed for tests
  nativeBuildInputs = [ sqlite ];

  goDeps = ./deps.nix;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Execute SQL against structured text like CSV or TSV";
    homepage = https://github.com/dinedal/textql;
    license = licenses.mit;
    maintainers = with maintainers; [ vrthra ];
  };
}
