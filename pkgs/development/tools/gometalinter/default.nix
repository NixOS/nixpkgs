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
  version = "3.0.0";

  goPackagePath = "github.com/alecthomas/gometalinter";
  excludedPackages = "\\(regressiontests\\)";

  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = "gometalinter";
    rev = "v${version}";
    sha256 = "06dd60531qp0hxfwnxnyi36d6div1j781jvcb99ykhgrg0kwmzq9";
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
    maintainers = with maintainers; [ kalbasit rvolosatovs ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
