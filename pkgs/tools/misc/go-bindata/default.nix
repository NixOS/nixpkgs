{ stdenv, lib, go, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "go-bindata";

  src = import ./deps.nix {
    inherit stdenv lib fetchFromGitHub;
  };

  buildInputs = [ go ];

  buildPhase = ''
    export GOPATH=$src
    go build -v -o go-bindata github.com/jteeuwen/go-bindata/go-bindata
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp go-bindata $out/bin
  '';

  meta = with lib; {
    homepage    = "https://github.com/jteeuwen/go-bindata";
    description = "A small utility which generates Go code from any file. Useful for embedding binary data in a Go program.";
    maintainers = with maintainers; [ cstrahan ];
    license     = licenses.cc0 ;
    platforms   = platforms.all;
  };
}
