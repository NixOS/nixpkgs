{ buildGoPackage
, deadcode
, errcheck
, fetchFromGitHub
, go
, go-check
, go-tools
, goconst
, gocyclo
, golint
, gosec
, gotools
, ineffassign
, maligned
, interfacer
, lib
, makeWrapper
, unconvert
}:

with lib;

let
  runtimeDeps = [
    deadcode
    errcheck
    go
    go-check
    go-tools
    goconst
    gocyclo
    golint
    gosec
    gotools
    ineffassign
    interfacer
    maligned
    unconvert
  ];

in buildGoPackage rec {
  name = "gometalinter-${version}";
  version = "2.0.11";

  goPackagePath = "github.com/alecthomas/gometalinter";
  excludedPackages = "\\(regressiontests\\)";

  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = "gometalinter";
    rev = "v${version}";
    sha256 = "08p7bwvhpgizif8qi59m8mm3mcny70x9msbk8m8vjpphsq55wha4";
  };

  postInstall = ''
    wrapProgram $bin/bin/gometalinter --prefix PATH : "${makeBinPath runtimeDeps}"
  '';

  buildInputs = [ makeWrapper ];

  allowGoReference = true;

  meta = with lib; {
    description = "Concurrently run Go lint tools and normalise their output";
    homepage = https://github.com/alecthomas/gometalinter;
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
