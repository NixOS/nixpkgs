{ stdenv, lib, go, fetchgit, fetchhg, fetchFromGitHub }:

let
  version = "0.0.1";
in

with lib;
stdenv.mkDerivation {
  name = "go-repo-root-${version}";

  src = import ./deps.nix {
    inherit stdenv lib fetchhg fetchFromGitHub;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build -v -o go-repo-root github.com/cstrahan/go-repo-root
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp go-repo-root $out/bin
  '';

  meta = with lib; {
    homepage    = "https://github.com/cstrahan/go-repo-root";
    maintainers = with maintainers; [ cstrahan ];
    license     = licenses.mit;
    platforms   = platforms.all;
  };
}
